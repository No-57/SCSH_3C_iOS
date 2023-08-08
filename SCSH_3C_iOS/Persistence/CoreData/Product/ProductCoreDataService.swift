//
//  ProductCoreDataService.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/8/7.
//

import Foundation
import CoreData
import Combine

public protocol ProductCoreDataServiceType {
    func get(name: String?) -> AnyPublisher<[Product], Error>
    func save(names: [String]) -> AnyPublisher<Void, Error>
}

public class ProductCoreDataService: ProductCoreDataServiceType {
    
    private let mapper: ProductCoreDataMapperType = ProductCoreDataMapper()
    
    public init() {}
    
    public func get(name: String?) -> AnyPublisher<[Product], Error> {
        Future<[Product], Error> { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.get(name: name))
        }
        .eraseToAnyPublisher()
    }
    
    public func save(names: [String]) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.save(names: names))
        }
        .eraseToAnyPublisher()
    }
    
    private func get(name: String?) -> Result<[Product], Error> {
        let context = CoreDataController.shared.container.newBackgroundContext()
        let fetchRequest = Product.fetchRequest()
        if let name = name, !name.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "name LIKE '*\(name)*'")
        }
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            let model = try context.fetch(fetchRequest)
            return .success(model)
            
        } catch {
            print("❌❌❌ ProductCoreDataService query is fail !")
            return .failure(error)
        }
    }
    
    private func save(names: [String]) -> Result<Void, Error> {
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
