//
//  HealthApiInterface.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/24.
//

import Foundation
import Moya

public struct HealthApiInterface: MoyaApiInterfaceType {
    public typealias OutputModel = ApiResponse<HealthApiModel>
    public typealias OutputError = ApiError

    public init() {}
    public var baseURL: URL = URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost8080)!
    public var path: String = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/health"
    public var method: Moya.Method = .get
    public var task: Moya.Task = .requestPlain
    public var headers: [String : String]? = .none
}

public struct HealthApiModel: Decodable, Equatable {
    public let health: String
    public let time: String
}
