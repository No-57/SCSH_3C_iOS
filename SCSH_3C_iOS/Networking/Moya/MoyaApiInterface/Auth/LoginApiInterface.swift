//
//  LoginApiInterface.swift
//  Networking
//
//  Created by 辜敬閎 on 2023/10/1.
//

import Foundation
import Moya

public struct LoginApiInterface: MoyaApiInterfaceType {
    public typealias OutputModel = ApiResponse<LoginApiModel>
    public typealias OutputError = ApiError

    private let parameter: LoginApiParameter
    
    public let baseURL: URL = URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost8080)!
    public let path: String = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/login"
    public let method: Moya.Method = .post
    public var task: Moya.Task { .requestCustomJSONEncodable(parameter, encoder: jsonEncoder) }
    public let headers: [String : String]? = ["Content-Type":"application/json", "accept": "application/json"]
    
    public init(password: String, target: String) {
        parameter = LoginApiParameter(password: password, target: target)
    }
}

struct LoginApiParameter: Encodable {
    let password: String
    let target: String
}

public struct LoginApiModel: Decodable, Equatable {
    public let accessToken: String
    public let refreshToken: String
}
