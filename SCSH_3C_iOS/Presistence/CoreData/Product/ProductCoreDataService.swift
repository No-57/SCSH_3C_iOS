//
//  ProductCoreDataService.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/8/7.
//

import Foundation
import CoreData

class ProductCoreDataService {
    
    func get() -> Result<[Product], Error> {
        .success([])
    }
    
    func save(names: [String]) -> Result<Void, Error> {
        .success(())
    }
}
