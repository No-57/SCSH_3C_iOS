//
//  MoyaApiInterfaceType.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/24.
//

import Foundation
import Moya

public protocol MoyaApiInterfaceType: TargetType {
    associatedtype OutputModel: Decodable
    associatedtype OutputError: Decodable & LocalizedError
    var jsonEncoder: JSONEncoder { get }
    var jsonDecoder: JSONDecoder { get }
}

public extension MoyaApiInterfaceType {
    
    var jsonEncoder: JSONEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        return jsonEncoder
    }
    
    var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
    
    var validationType: ValidationType { .successAndRedirectCodes }
}

public struct ApiResponse<Data: Decodable>: Decodable {
    public let code: Int
    public let data: Data
}

public struct EmptyApiResponse: Decodable {
    public let code: Int
}

public struct ApiError: Decodable, LocalizedError, Equatable {
    public let code: Int
    public let extra: String?
    public let message: String
}
