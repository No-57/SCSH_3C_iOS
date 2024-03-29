//
//  DistributorApiInterface.swift
//  Networking
//
//  Created by 辜敬閎 on 2023/12/4.
//

import Foundation
import Moya

public class DistributorApiInterface: MoyaApiInterfaceType {
    public typealias OutputModel = ApiResponse<[Distributor]>
    public typealias OutputError = ApiError

    public let baseURL: URL = URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost8080)!
    public let path: String = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/distributors"
    public let method: Moya.Method = .get
    public let task: Moya.Task
    public let headers: [String : String]? = .none
    
    public init(limit: Int? = nil) {
        if let limit = limit {
            task = .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.default)
        } else {
            task = .requestPlain
        }
    }
}

public struct Distributor: Codable, Equatable {
    public struct Product: Codable, Equatable {
        public let id: Int
        public let image: String
    }
    
    public let id: Int
    public let name: String
    public let description: String
    public let brandImage: String
    public let products: [Product]
}
