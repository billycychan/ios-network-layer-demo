//
//  BaseKMBResponse.swift
//  ios-network-layer-demo
//
//  Created by billy.cychan on 7/6/2021.
//

import Foundation

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
