//
//  MoyaNetworkService.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/24.
//

import Foundation
import Moya

final class MoyaNetworkService: RemoteDataSourceType {
    
    static var shared = MoyaNetworkService()

    func fetch<T: MoyaApiInterfaceType>(apiInterface: T) {
        let moyaProvider = MoyaProvider<T>()

        moyaProvider.request(apiInterface) { result in
            
            switch result {
            case .success(let response):
                do {
                    let result = try apiInterface.jsonDecoder.decode(T.OutputModel.self, from: response.data)

                    print("🎉🎉🎉")
                    print(result)
                } catch (let error) {
                    print("❌❌")
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print("❌❌❌")
                print(error.localizedDescription)
            }
            
        }
    }
}
