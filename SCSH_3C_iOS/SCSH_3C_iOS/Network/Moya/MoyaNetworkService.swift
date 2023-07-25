//
//  MoyaNetworkService.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/24.
//

import Foundation
import Moya
import Combine

final class MoyaNetworkService: RemoteDataSourceType {
    
    static var shared = MoyaNetworkService()
    
    func fetch<T: MoyaApiInterfaceType>(apiInterface: T, success: @escaping (T.OutputModel) -> Void, failure: @escaping (Error) -> Void) {
        let moyaProvider = MoyaProvider<T>()

        moyaProvider.request(apiInterface) { result in
            
            switch result {
            case .success(let response):
                do {
                    let outputModel = try apiInterface.jsonDecoder.decode(T.OutputModel.self, from: response.data)

                    success(outputModel)
                    
                } catch (let error) {
                    print("❌❌ \(error.localizedDescription)")
                    failure(error)
                }
            case .failure(let error):
                print("❌❌❌ \(error.localizedDescription)")
                failure(error)
            }
        }
    }
}
