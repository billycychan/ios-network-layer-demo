//
//  RouteList.swift
//  ios-network-layer-demo
//
//  Created by billy.cychan on 7/6/2021.
//

import Foundation

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
