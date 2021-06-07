//
//  DecodableResponseTargetType.swift
//  ios-network-layer-demo
//
//  Created by billy.cychan on 7/6/2021.
//

import Foundation
import Moya

protocol DecodableResponseTargetType: TargetType {
  associatedtype ResponseType: Decodable
}
