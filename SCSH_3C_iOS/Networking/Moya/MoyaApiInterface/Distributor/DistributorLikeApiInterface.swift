//
//  DistributorLikeApiInterface.swift
//  Networking
//
//  Created by 辜敬閎 on 2023/12/9.
//

import Foundation
import Moya

public protocol DistributorLikeApiInterfaceType: MoyaApiInterfaceType {}

public extension DistributorLikeApiInterfaceType {
    var baseURL: URL {
        URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost8080)!
    }
    
    var headers: [String: String]? {
        // TODO: Authentication is required.
        nil
    }
}

public class DistributorLikeApiInterface {
    
    public class Get: DistributorLikeApiInterfaceType {
        public typealias OutputModel = ApiResponse<[DistributorLike]>
        public typealias OutputError = ApiError
        
        // TODO: Authentication is required.
        public init() {}

        public var path: String = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/distributors/like"
        public let method: Moya.Method = .get
        public let task: Moya.Task = .requestPlain
    }
    
    public class Post: DistributorLikeApiInterfaceType {
        public typealias OutputModel = EmptyApiResponse
        public typealias OutputError = ApiError
        
        // TODO: Authentication is required.
        public init(id: Int) {
            path = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/distributors/\(id)/like"
        }
        
        public let path: String
        public let method: Moya.Method = .post
        public let task: Moya.Task = .requestPlain
    }
    
    public class Delete: DistributorLikeApiInterfaceType {
        public typealias OutputModel = EmptyApiResponse
        public typealias OutputError = ApiError
        
        // TODO: Authentication is required.
        public init(id: Int) {
            path = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/distributors/\(id)/like"
        }
        
        public let path: String
        public let method: Moya.Method = .delete
        public let task: Moya.Task = .requestPlain
    }
}

public struct DistributorLike: Codable {
    public let id: Int
}
