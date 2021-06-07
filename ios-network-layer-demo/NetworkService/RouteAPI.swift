//
//  API.swift
//  ios-network-layer-demo
//
//  Created by billy.cychan on 7/6/2021.
//

import Foundation
import Moya

protocol RouteAPITargetType: DecodableResponseTargetType {}

extension RouteAPITargetType {
    var baseURL: URL { return URL(string: "https://data.etabus.gov.hk/")! }
    var headers: [String : String]? { return nil }
    var sampleData: Data { return Data() }
}

enum RouteAPI {
    struct GetRouteList: RouteAPITargetType {
        typealias ResponseType = BaseKMBResponse<[Route]>
        
        var path: String { return "v1/transport/kmb/route/" }
        var method: Moya.Method { return .get }
        var task: Task { return .requestPlain }
    }
}
