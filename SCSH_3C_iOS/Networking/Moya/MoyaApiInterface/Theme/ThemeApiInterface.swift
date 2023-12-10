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

    public let baseURL: URL = URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost8080)!
    public let path: String
    public let method: Moya.Method = .get
    public let task: Moya.Task = .requestPlain
    public let headers: [String : String]? = .none
    
    public init(type: String) {
        path = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/themes/\(type)"
    }
}

public struct Theme: Codable, Equatable {
    public let id: Int
    public let type: String
    public let code: String
}
