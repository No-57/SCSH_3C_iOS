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

    public init(code: String? = nil) {
        if let code = code {
            task = .requestParameters(parameters: ["code": code], encoding: URLEncoding.default)
        } else {
            task = .requestPlain
        }
    }
    
    public var baseURL: URL = URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost8080)!
    public var path: String = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/boards"
    public var method: Moya.Method = .get
    public let task: Moya.Task
    public var headers: [String : String]? = .none
}

public struct Board: Codable, Equatable {
    public let id: Int
    public let code: String
    public let imageUrl: String
    public let actionType: String?
    public let action: String?
}
