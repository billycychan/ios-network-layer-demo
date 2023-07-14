# ios-network-layer-demo

## Problem
In today's development of modern applications, `Moya` and `Alamofire` are commonly used to facilitate the creation of the network layer. It is often recommended to implement API endpoints using an `enum`, which can be appealing. However, as the number of API endpoints increases, **the enum file becomes excessively large and difficult to manage in separate files**. Additionally, **making changes such as removing, editing, or adding a single endpoint can be a daunting task**. This complexity makes the maintenance of the network layer more challenging. 

## Solution
One possible solution to address the challenges of managing a large and complex enum file for API endpoints in the network layer is to use a modular approach. Instead of having a single enum file, you can divide the endpoints into multiple smaller files based on their logical grouping or functionality.

For me, I just make use of  `struct` instead of `enum` . The below demonstration of how I construct and use the network layer 

### ViewController.swift

```swift
import UIKit
import Alamofire
import PromiseKit
import Moya
import ProgressHUD

override func viewDidLoad() {
        super.viewDidLoad()
        // ...
        firstly { 
            interactor.getRouteList() 
            }
        .done { routes in
            print("done")
            routes.forEach {
                print($0)
            }
            ProgressHUD.showSuccess("success")
        }
        .catch { error in
            print("error")
            ProgressHUD.showError("error")
        }
    }
```

### ViewControllerInteractor.swift
```swift
protocol ViewControllerInteractorProtocol: class {
    func getRouteList() -> Promise<[Route]>
    
}

public class ViewControllerInteractor: ViewControllerInteractorProtocol {
    let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getRouteList() -> Promise<[Route]>  {
        return Promise<[Route]> { seal in
            let routeList = RouteAPI.GetRouteList()
            networkService.request(routeList).done { response in
                seal.fulfill(response.data)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
```

See? Pay attention to the `func getRouteList() -> Promise<[Route]>` method. All you need to do is create an instance of `RouteAPI.GetRouteList` and pass it to the request function provided by the `networkService`. The `networkService` will take care of the API request automatically and return the data response in a clean and easy-to-read manner.

But why? and How?


Let's take a look at `TargetType` from Moya.

In Moya, `TargetType` is a protocol provided by the Moya library that defines the requirements for creating an API target or endpoint. It serves as a blueprint for creating API request targets and provides a clear structure for defining various aspects of an API request.

```swift
/// The protocol used to define the specifications necessary for a `MoyaProvider`.
public protocol TargetType {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Moya.Method { get }

    /// Provides stub data for use in testing. Default is `Data()`.
    var sampleData: Data { get }

    /// The type of HTTP task to be performed.
    var task: Task { get }

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}
```

---

Then let's take a look at `DecodableResponseTargetType`
### DecodableResponseTargetType
```swift
protocol DecodableResponseTargetType: TargetType {
  associatedtype ResponseType: Decodable
}
```

The `DecodableResponseTargetType` protocol is created by inheriting properties from the `TargetType` protocol. It introduces an associated type called `ResponseType`, which represents the model type that will be used to decode the response data.

When a class, enum, or struct conforms to the `DecodableResponseTargetType`, it is required to specify the type of response (`ResponseType`) it expects to receive. This ensures that the API targets provide a clear definition of the model structure needed for decoding the response data.

In this project, we use [Route List Data@DATA.GOV.HK](https://data.etabus.gov.hk/v1/transport/kmb/route/) as an example. 

### BaseKMBResponse
```swift
// Since all the response have the same pattern of format, only the `data` is different. 
// We use generic to abstract the response.
public struct BaseKMBResponse<T: Decodable>: Decodable {
    public let type: String
    public let version: String
    public let data: T

    enum CodingKeys: String, CodingKey {
        case type, version, data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        version = try container.decode(String.self, forKey: .version)
        data = try container.decode(T.self, forKey: .data)
    }
}
```
### Route
```swift
// Then we define the Route data
public struct Route: Decodable {
    public let route: String
    public let bound: String
    public let serviceType: String
    public let origEN: String
    public let destEN: String


    enum CodingKeys: String, CodingKey {
        case route
        case bound
        case serviceType = "service_type"
        case origEN = "orig_en"
        case destEN = "dest_en"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        route = try container.decode(String.self, forKey: .route)
        bound = try container.decode(String.self, forKey: .bound)
        serviceType = try container.decode(String.self, forKey: .serviceType)
        origEN = try container.decode(String.self, forKey: .origEN)
        destEN = try container.decode(String.self, forKey: .destEN)
    }
}

extension Route {
    var description: String {
        return "Route: \(self.route), from: \(self.origEN), to: \(self.destEN)"
    }
}
```

### RouteAPI
```swift
// Specific TargetType for all Route related API, for grouping
protocol RouteAPITargetType: DecodableResponseTargetType {}

// Provide default implementation for `RouteAPITargetType`
extension RouteAPITargetType {
    var baseURL: URL { return URL(string: "https://data.etabus.gov.hk/")! }
    var headers: [String : String]? { return nil }
    var sampleData: Data { return Data() }
}

enum RouteAPI {

    // Start to construct the API endpoint with `struct`
    struct GetRouteList: RouteAPITargetType {
        typealias ResponseType = BaseKMBResponse<[Route]>
        
        var path: String { return "v1/transport/kmb/route/" }
        var method: Moya.Method { return .get }
        var task: Task { return .requestPlain }
    }
}

```

After setting up our model, we need to define our `NetworkService`

The provided code defines a network service in Swift, implementing the `NetworkServiceProtocol`. It utilizes the Moya library for handling network requests. The `NetworkService` class has a provider property of type `MoyaProvider<MultiTarget>`, which is responsible for making the actual network requests. The request method takes a generic parameter `Request`, which conforms to the `DecodableResponseTargetType` protocol, representing the API request being made. It returns a `Promise` that will resolve to the expected response type defined by `Request`. Inside the method, the request is executed using the provider, and the result is handled accordingly, either fulfilling the promise with the mapped response or rejecting it with an error.

### NetworkService.swift
```swift
protocol NetworkServiceProtocol {
    var provider: MoyaProvider<MultiTarget>  { get }
    func request<Request: DecodableResponseTargetType>(_ request: Request) -> Promise<Request.ResponseType>
}

open class NetworkService: NetworkServiceProtocol {
    var provider: MoyaProvider<MultiTarget>
    
    init(provider: MoyaProvider<MultiTarget>) {
        self.provider = provider
    }
    
    func request<Request: DecodableResponseTargetType>(_ request: Request) -> Promise<Request.ResponseType> {
        let target = MultiTarget.init(request)
        return Promise<Request.ResponseType> { seal in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let mappedResponse = try response.map(Request.ResponseType.self)
                        seal.fulfill(mappedResponse)
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

```

Bravo! We made it. 

To improve the code organization, it is suggested to extract the struct `GetRouteList` into its own separate file by using an extension to an enum `RouteAPI`. This will help in maintaining a clean and modular code structure.


```swift
enum RouteAPI {}

// GetRouteList.swift
extension RouteAPI {
    struct GetRouteList: RouteAPITargetType {
        typealias ResponseType = BaseKMBResponse<[Route]>
        
        var path: String { return "v1/transport/kmb/route/" }
        var method: Moya.Method { return .get }
        var task: Task { return .requestPlain }
    }
}

// AnotherRouteRelatedEndpoint.swift
extension RouteAPI {
    struct AnotherRouteRelatedEndpoint: RouteAPITargetType {
        typealias ResponseType = BaseKMBResponse<[SomeModel]>
        
        var path: String { return "v1/transport/kmb/route/some-path" }
        var method: Moya.Method { return .get }
        var task: Task { return .requestPlain }
    }
}

// ...

```

## Conclusion
In conclusion, by utilizing a modular approach and leveraging protocols and libraries like Moya, the complexity of managing a large and complex enum file for API endpoints in the network layer is significantly reduced. The result is a clean, organized, and easily maintainable network layer that can adapt to the evolving needs of modern application development.


