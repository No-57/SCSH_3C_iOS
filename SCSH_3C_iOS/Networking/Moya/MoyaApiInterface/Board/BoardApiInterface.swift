//
//  BoardApiInterface.swift
//  Networking
//
//  Created by 辜敬閎 on 2023/11/30.
//

import Foundation
import Moya

public class BoardApiInterface: MoyaApiInterfaceType {
    public typealias OutputModel = ApiResponse<[Board]>
    public typealias OutputError = ApiError

    public let baseURL: URL = URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost8080)!
    public let path: String = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/boards"
    public let method: Moya.Method = .get
    public let task: Moya.Task
    public let headers: [String : String]? = .none
    
    public init(code: String? = nil, limit: Int) {
        if let code = code {
            task = .requestParameters(parameters: ["code": code, "limit": limit], encoding: URLEncoding.default)
        } else {
            task = .requestPlain
        }
    }
}

public struct Board: Codable, Equatable {
    public let id: Int
    public let code: String
    public let imageUrl: String
    public let actionType: String?
    public let action: String?
}
