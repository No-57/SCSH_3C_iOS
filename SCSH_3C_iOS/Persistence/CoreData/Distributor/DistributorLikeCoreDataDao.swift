//
//  DistributorLikeCoreDataDao.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/12/4.
//

import CoreData

protocol DistributorLikeCoreDataDaoType {
    func get(id: Int64?) throws -> [Distributor_Like]
    
    func insert(likes: [Distributor_Like]) throws
    
    func insert(id: Int64) throws
    
    func delete(id: Int64) throws
    
    func truncate() throws
}

class DistributorLikeCoreDataDao: DistributorLikeCoreDataDaoType {
    
    func get(id: Int64?) throws -> [Distributor_Like] {
        let fetchRequest = Distributor_Like.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        if let id = id {
            fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
        }
        
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        do {
            let result = try context.fetch(fetchRequest)
            try context.save()
            
            return result
            
        } catch {
            print("❌❌❌ DistributorLikeCoreDataDao get fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
    
    func insert(likes: [Distributor_Like]) throws {
        
        guard let context = likes.first?.managedObjectContext else {
            throw CoreDataError.invalidManagedObjectContext
        }
        
        do {
            try context.save()
            
        } catch {
            print("❌❌❌ DistributorLikeCoreDataDao insert(likes:) fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
    
    func insert(id: Int64) throws {
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        let like = Distributor_Like(context: context)
        like.id = id
        
        do {
            try context.save()
            
        } catch {
            print("❌❌❌ DistributorLikeCoreDataDao insert(id:) fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
    
    func delete(id: Int64) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Distributor_Like.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        do {
            try context.execute(deleteRequest)
            
        } catch {
            print("❌❌❌ DistributorLikeCoreDataDao delete fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
    
    func truncate() throws {
        let truncateRequest = NSBatchDeleteRequest(fetchRequest: Distributor_Like.fetchRequest())
        
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        do {
            try context.execute(truncateRequest)
            
        } catch {
            print("❌❌❌ DistributorLikeCoreDataDao truncate fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
    
}
