//
//  MoyaApiInterfaceType.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/24.
//

import Foundation
import Moya

protocol MoyaApiInterfaceType: TargetType {
    associatedtype OutputModel: Decodable
    var jsonDecoder: JSONDecoder { get set }
}
