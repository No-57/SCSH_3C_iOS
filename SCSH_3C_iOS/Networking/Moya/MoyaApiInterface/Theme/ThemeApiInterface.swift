//
//  ThemeApiInterface.swift
//  Networking
//
//  Created by 辜敬閎 on 2023/12/2.
//

import Foundation
import Moya

public class ThemeApiInterface: MoyaApiInterfaceType {
    public typealias OutputModel = ApiResponse<[Theme]>
    public typealias OutputError = ApiError

    public init(type: String) {
        path = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/themes/\(type)"
    }
    
    public var baseURL: URL = URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost8080)!
    public var path: String
    public var method: Moya.Method = .get
    public let task: Moya.Task = .requestPlain
    public var headers: [String : String]? = .none
}

public struct Theme: Codable, Equatable {
    public let id: Int
    public let type: String
    public let code: String
}
