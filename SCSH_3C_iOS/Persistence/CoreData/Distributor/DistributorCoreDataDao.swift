//
//  DistributorCoreDataDao.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/12/4.
//

import CoreData

protocol DistributorCoreDataDaoType {
    func get(id: Int64?) throws -> [Distributor]
    
    func insert(distributors: [Distributor]) throws
    
    func truncate() throws
}

class DistributorCoreDataDao: DistributorCoreDataDaoType {
    
    private let relationshipLike = "distributor_like"
    
    func get(id: Int64?) throws -> [Distributor] {
        let fetchRequest = Distributor.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.relationshipKeyPathsForPrefetching = [relationshipLike]

        if let id = id {
            fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
        }
        
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        do {
            let result = try context.fetch(fetchRequest)
            try context.save()
            
            return result
            
        } catch {
            print("❌❌❌ DistributorCoreDataDao get fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
    
    func insert(distributors: [Distributor]) throws {
        
        guard let context = distributors.first?.managedObjectContext else {
            throw CoreDataError.invalidManagedObjectContext
        }
        
        do {
            try context.save()
            
        } catch {
            print("❌❌❌ DistributorCoreDataDao insert fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
    
    func truncate() throws {
        let truncateRequest = NSBatchDeleteRequest(fetchRequest: Distributor.fetchRequest())
        
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        do {
            try context.execute(truncateRequest)
            
        } catch {
            print("❌❌❌ DistributorCoreDataDao truncate fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
}
