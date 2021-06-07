//
//  ViewController.swift
//  ios-network-layer-demo
//
//  Created by billy.cychan on 4/6/2021.
//

import UIKit
import Alamofire
import PromiseKit
import Moya

class ViewController: UIViewController {
    
    let interactor: ViewControllerInteractorProtocol
    
    init(interactor: ViewControllerInteractorProtocol) {
        self.interactor = interactor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let provider = MoyaProvider<API>()
//        let networkService: NetworkServiceProtocol = NetworkService(provider: provider)
//        // Show Toast
//        networkService.getRouteList()
//            .done { response in
//                let list = response.data
//                list.forEach { route in
//                    print(route.route)
//                }
//            }
//            .catch { error in
//                // throw error
//            }
//            .finally {
//                
//            }
    }
}

