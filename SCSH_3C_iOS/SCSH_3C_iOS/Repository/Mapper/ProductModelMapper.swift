//
//  ProductModelMapper.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/31.
//

import Foundation
import Presistence

protocol ProductModelMapperType {
    func transform(apiModel: ProductApiModel) -> [Product]
    func transform(coreDataProducts: [Presistence.Product]) -> [Product]
}

class ProductModelMapper: ProductModelMapperType {
    func transform(coreDataProducts: [Presistence.Product]) -> [Product] {
        coreDataProducts.map { coreDataProduct in
            Product(name: coreDataProduct.name ?? "unknown")
        }
    }
    
    func transform(apiModel: ProductApiModel) -> [Product] {
        apiModel.names.map { name in
            Product(name: name)
        }
    }
}
