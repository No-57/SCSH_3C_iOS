//
//  MoyaApiInterfaceType.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/24.
//

import Foundation
import Moya

public protocol MoyaApiInterfaceType: TargetType {
    associatedtype OutputModel: Decodable
    var jsonEncoder: JSONEncoder { get }
    var jsonDecoder: JSONDecoder { get }
}

public extension MoyaApiInterfaceType {
    var jsonEncoder: JSONEncoder { JSONEncoder() }
    var jsonDecoder: JSONDecoder { JSONDecoder() }
    var validationType: ValidationType { .successAndRedirectCodes }
}
