//
//  MoyaNetworkFacade.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/31.
//

import Foundation
import Moya
import Combine

public protocol MoyaNetworkFacadeType {
    func fetch<T: MoyaApiInterfaceType>(apiInterface: T) -> AnyPublisher<T.OutputModel, Error>
}

public class MoyaNetworkFacade: MoyaNetworkFacadeType {
    
    private var activeService: Any?
    
    public init() {}
    
    public func fetch<T: MoyaApiInterfaceType>(apiInterface: T) -> AnyPublisher<T.OutputModel, Error> {
        Future<T.OutputModel, Error> { [weak self] promise in
            guard let self = self else { return }
            
            self.fetch(apiInterface: apiInterface, success: { outputModel in
                promise(.success(outputModel))
            }, failure: { error in
                promise(.failure(error))
            })
        }
        .eraseToAnyPublisher()
    }
    
    private func fetch<T: MoyaApiInterfaceType>(apiInterface: T, success: @escaping (T.OutputModel) -> Void, failure: @escaping (Error) -> Void) {
        let provider = MoyaProvider<T>()
        let networkService = MoyaNetworkService(moyaProvider: provider, moyaApiInterface: apiInterface)
        activeService = networkService // ⚠️ retain it temporarily
        
        networkService.fetch(success: success, failure: failure)
    }
}
