//
//  ProductApiInterface.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/25.
//

import Foundation
import Moya

struct ProductApiInterface: MoyaApiInterfaceType {
    var jsonDecoder: JSONDecoder = JSONDecoder()
    
    typealias OutputModel = ProductApiModel
    
    init(name: String? = nil) {
        if let name = name {
            task = .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        } else {
            task = .requestPlain
        }
    }
    
    var baseURL: URL = URL(string: NetworkConstants.httpUrlScheme + NetworkConstants.localHost80)!
    var path: String = "devices"
    var method: Moya.Method = .get
    var task: Moya.Task
    var headers: [String : String]? = .none
}

struct ProductApiModel: Decodable {
    let names: [String]
}
