//
//  MoyaNetworkFacade.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/31.
//

import Foundation
import Moya

class MoyaNetworkFacade {
    
    private var activeService: Any?
    
    func fetch<T: MoyaApiInterfaceType>(apiInterface: T, success: @escaping (T.OutputModel) -> Void, failure: @escaping (Error) -> Void) {
        let provider = MoyaProvider<T>()
        let networkService = MoyaNetworkService(moyaProvider: provider, moyaApiInterface: apiInterface)
        activeService = networkService // ⚠️ retain it temporarily
        
        networkService.fetch(success: success, failure: failure)
    }
}
