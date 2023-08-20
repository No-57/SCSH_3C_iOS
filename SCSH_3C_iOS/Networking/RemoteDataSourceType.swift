//
//  RemoteDataSourceType.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/24.
//

import Foundation

protocol RemoteDataSourceType {
    static var shared: Self { get }
}
