//
//  HealthInterface.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/24.
//

import Foundation
import Moya

struct HealthInterface: MoyaApiInterfaceType {
    typealias OutputModel = HealthApiModel
    
    var baseURL: URL = URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost80)!
    var path: String = "health"
    var method: Moya.Method = .get
    var task: Moya.Task = .requestPlain
    var headers: [String : String]? = .none
}

struct HealthApiModel: Decodable, Equatable {
    let message: String
}
