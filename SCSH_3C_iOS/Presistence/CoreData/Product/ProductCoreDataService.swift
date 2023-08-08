//
//  ProductCoreDataService.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/8/7.
//

import Foundation
import CoreData

protocol ProductCoreDataServiceType {
    func get() -> Result<[Product], Error>
    func save(names: [String]) -> Result<Void, Error>
}

class ProductCoreDataService: ProductCoreDataServiceType {
    
    private let mapper: ProductCoreDataMapperType = ProductCoreDataMapper()
    
    func get() -> Result<[Product], Error> {
        let context = CoreDataController.shared.container.newBackgroundContext()
        let fetchRequest = Product.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let model = try context.fetch(fetchRequest)
            return .success(model)
            
        } catch {
            print("❌❌❌ ProductCoreDataService query is fail !")
            return .failure(error)
        }
    }
    
    func save(names: [String]) -> Result<Void, Error> {
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        // truncate table
        truncate(context: context)
        
        do {
            mapper.transform(names: names, context: context)
            
            try context.save()
            return .success(())
            
        } catch {
            print("❌❌❌ ProductCoreDataService save fail !")
            return .failure(error)
        }
    }
    
    private func truncate(context: NSManagedObjectContext) {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Product.fetchRequest())
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("❌❌❌ ProductCoreDataService truncate fail !")
        }
    }
}
