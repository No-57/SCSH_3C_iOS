//
//  ProductCoreDataMapper.swift
//  Presistence
//
//  Created by 辜敬閎 on 2023/8/8.
//

import Foundation
import CoreData

protocol ProductCoreDataMapperType {
    func transform(names: [String], context: NSManagedObjectContext)
}

class ProductCoreDataMapper: ProductCoreDataMapperType {
    func transform(names: [String], context: NSManagedObjectContext) {
        for name in names {
            let product = Product(context: context)
            product.name = name
        }
    }
}
