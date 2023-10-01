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
                self.handleSuccess(data: response.data, success: success, failure: failure)
                
            case .failure(let error):
                self.handleFailure(error: error, failure: failure)
            }
        }
    }
    
    private func handleSuccess(data: Data, success: @escaping (T.OutputModel) -> Void, failure: @escaping (Error) -> Void) {
        do {
            let outputModel = try moyaApiInterface.jsonDecoder.decode(T.OutputModel.self, from: data)

            success(outputModel)

        } catch (let error) {
            print("❌❌ \(error.localizedDescription)")
            failure(error)
        }
    }
    
    private func handleFailure(error: MoyaError, failure: @escaping (Error) -> Void) {
        switch error {
        case .underlying(let error, let response):
            handleUnderlyingError(underlyingError: error, response: response, failure: failure)
            
        default:
            print("❌❌❌ \(error.localizedDescription)")
            failure(error)
        }
    }
    
    private func handleUnderlyingError(underlyingError: Error, response: Response?, failure: (Error) -> Void) {
        guard let response = response else {
            failure(underlyingError)
            return
        }
        
        do {
            let outputError = try moyaApiInterface.jsonDecoder.decode(T.OutputError.self, from: response.data)
            failure(outputError)
        } catch {
            failure(error)
        }
    }
}
