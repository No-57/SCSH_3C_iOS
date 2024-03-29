//
//  TokenApiInterface.swift
//  Networking
//
//  Created by 辜敬閎 on 2023/10/2.
//

import Foundation
import Moya

public struct TokenApiInterface: MoyaApiInterfaceType {
    public typealias OutputModel = ApiResponse<TokenApiModel>
    public typealias OutputError = ApiError

    private let parameter: TokenApiParameter
    
    public let baseURL: URL = URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost8080)!
    public let path: String = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/token"
    public let method: Moya.Method = .patch
    public var task: Moya.Task { .requestCustomJSONEncodable(parameter, encoder: jsonEncoder) }
    public let headers: [String : String]? = ["Content-Type":"application/json", "accept": "application/json"]
    
    public init(refreshToken: String) {
        self.parameter = TokenApiParameter(refreshToken: refreshToken)
    }
}

struct TokenApiParameter: Encodable {
    let refreshToken: String
}

public struct TokenApiModel: Decodable, Equatable {
    public let accessToken: String
    public let refreshToken: String
}
