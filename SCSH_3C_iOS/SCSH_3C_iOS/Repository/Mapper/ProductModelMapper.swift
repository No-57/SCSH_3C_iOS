//
//  ProductModelMapper.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/31.
//

import Foundation

protocol ProductModelMapperType {
    func transform(apiModel: ProductApiModel) -> [Product]
}

class ProductModelMapper: ProductModelMapperType {
    
    func transform(apiModel: ProductApiModel) -> [Product] {
        apiModel.names.map { name in
            Product(name: name)
        }
    }
}
