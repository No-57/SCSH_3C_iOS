//
//  ThemeCoreDataDao.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/12/3.
//

import CoreData

protocol ThemeCoreDataDaoType {
    func get(type: String) throws -> [Theme]
    
    func insert(themes: [Theme]) throws
    
    func delete(types: [String]) throws
    
    func truncate() throws
}

class ThemeCoreDataDao: ThemeCoreDataDaoType {
    
    func get(type: String) throws -> [Theme] {
        let fetchRequest = Theme.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "type == %@", type)
        
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        do {
            let result = try context.fetch(fetchRequest)
            try context.save()
            
            return result
            
        } catch {
            print("❌❌❌ ThemeCoreDataDao get fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
    
    func insert(themes: [Theme]) throws {
        guard let context = themes.first?.managedObjectContext else {
            throw CoreDataError.invalidManagedObjectContext
        }
        
        do {
            try context.save()
            
        } catch {
            print("❌❌❌ ThemeCoreDataDao insert fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
    
    func delete(types: [String]) throws {
        guard !types.isEmpty else {
            return
        }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Theme.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type IN %@", types)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        do {
            
            try context.execute(deleteRequest)
            
        } catch {
            print("❌❌❌ ThemeCoreDataDao delete fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
    
    func truncate() throws {
        let truncateRequest = NSBatchDeleteRequest(fetchRequest: Theme.fetchRequest())
        
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        do {
            try context.execute(truncateRequest)
            try context.save()
            
        } catch {
            print("❌❌❌ ThemeCoreDataDao truncate fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
}
