//
//  Distributor.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/11/13.
//

import Foundation

struct Distributor {
    struct Product {
        let id: String
        let image: URL
    }
    
    let id: String
    let name: String
    let description: String
    let brandImage: URL
    let products: [Product]
}
