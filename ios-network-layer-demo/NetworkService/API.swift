//
//  API.swift
//  ios-network-layer-demo
//
//  Created by billy.cychan on 7/6/2021.
//

import Foundation
import Moya

enum API {
    case getRouteList
}

extension API: TargetType {
    var baseURL: URL {
        switch self {
        case .getRouteList:
            return URL(string: "https://data.etabus.gov.hk/")!
        }
    }
    
    var path: String {
        switch self {
        case .getRouteList:
            return "/v1/transport/kmb/route/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRouteList:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getRouteList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
