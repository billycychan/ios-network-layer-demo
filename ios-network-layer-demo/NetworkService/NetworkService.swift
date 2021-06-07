//
//  NetworkService.swift
//  ios-network-layer-demo
//
//  Created by billy.cychan on 7/6/2021.
//

import Foundation
import Moya
import PromiseKit

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
