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
    var provider: MoyaProvider<API>  { get }
    func getRouteList() -> Promise<BaseKMBResponse<[Route]>>
}

open class NetworkService: NetworkServiceProtocol {
    var provider: MoyaProvider<API>
    
    init(provider: MoyaProvider<API>) {
        self.provider = provider
    }
    
    func getRouteList() -> Promise<BaseKMBResponse<[Route]>> {
        return Promise<BaseKMBResponse<[Route]>> { seal in
            provider.request(.getRouteList) { result in
                switch result {
                case .success(let response):
                    do {
                        let list = try response.map(BaseKMBResponse<[Route]>.self)
                        seal.fulfill(list)
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
