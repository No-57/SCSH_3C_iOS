//
//  MoyaNetworkService.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/24.
//

import Foundation
import Moya

class MoyaNetworkService<T: MoyaApiInterfaceType> {
    
    private let moyaProvider: MoyaProvider<T>
    private let moyaApiInterface: T
    
    init(moyaProvider: MoyaProvider<T>, moyaApiInterface: T) {
        self.moyaProvider = moyaProvider
        self.moyaApiInterface = moyaApiInterface
    }
    
    func fetch(success: @escaping (T.OutputModel) -> Void, failure: @escaping (Error) -> Void) {
        
        moyaProvider.request(moyaApiInterface) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):

                do {
                    let outputModel = try self.decode(jsonDecoder: self.moyaApiInterface.jsonDecoder, data: response.data)

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
    
    private func decode(jsonDecoder: JSONDecoder, data: Data) throws -> T.OutputModel {
        try jsonDecoder.decode(T.OutputModel.self, from: data)
    }
}
