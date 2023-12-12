//
//  Product.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/12/11.
//

import Foundation

struct Product {
    struct Distributor {
        let id: Int
        let name: String
    }
    
    let id: Int
    let name: String
    let image: URL?
    let distributor: Distributor
    let specialPrice: String
    let tagPrice: String
    let isLiked: Bool
}
