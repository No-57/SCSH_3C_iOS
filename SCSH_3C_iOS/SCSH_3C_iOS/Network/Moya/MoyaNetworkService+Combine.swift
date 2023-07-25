//
//  MoyaNetworkService+Combine.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/24.
//

import Foundation
import Moya
import Combine

extension MoyaNetworkService {
    
    func fetch<T: MoyaApiInterfaceType>(apiInterface: T) -> AnyPublisher<T.OutputModel, Error> {
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
}
