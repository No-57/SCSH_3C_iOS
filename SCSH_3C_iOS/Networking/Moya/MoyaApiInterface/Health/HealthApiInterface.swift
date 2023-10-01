//
//  HealthApiInterface.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/24.
//

import Foundation
import Moya

struct HealthApiInterface: MoyaApiInterfaceType {
    
    typealias OutputModel = HealthApiModel
    typealias OutputError = ApiError

    var baseURL: URL = URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost8080)!
    var path: String = "\(NetworkConstants.apiRootPath)/\(NetworkConstants.apiVersion)/health"
    var method: Moya.Method = .get
    var task: Moya.Task = .requestPlain
    var headers: [String : String]? = .none
}

struct HealthApiModel: Decodable, Equatable {
    let message: String
}
