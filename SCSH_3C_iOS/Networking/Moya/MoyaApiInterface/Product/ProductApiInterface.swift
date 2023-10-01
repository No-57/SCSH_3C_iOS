//
//  ProductApiInterface.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/25.
//

import Foundation
import Moya

public struct ProductApiInterface: MoyaApiInterfaceType {
    public typealias OutputModel = ProductApiModel
    
    public init(name: String? = nil) {
        if let name = name {
            task = .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        } else {
            task = .requestPlain
        }
    }
    
    public var baseURL: URL = URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost8080)!
    public var path: String = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/devices"
    public var method: Moya.Method = .get
    public var task: Moya.Task
    public var headers: [String : String]? = .none
}

public struct ProductApiModel: Decodable, Equatable {
    public let names: [String]
}
