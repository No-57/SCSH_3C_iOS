//
//  BoardCoreDataDao.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/12/2.
//

import CoreData

protocol BoardCoreDataDaoType {
    func get(code: String?) throws -> [Board]
    
    func insert(boards: [Board]) throws

    func delete(boards: [Board]) throws
    
    func truncate() throws
}

class BoardCoreDataDao: BoardCoreDataDaoType {
    
    func get(code: String?) throws -> [Board] {
        
        let fetchRequest = Board.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        if let code = code {
            fetchRequest.predicate = NSPredicate(format: "code == %@", code)
        }

        let context = CoreDataController.shared.container.newBackgroundContext()
        
        do {
            let results = try context.fetch(fetchRequest)
            try context.save()
            
            return results
            
        } catch {
            print("❌❌❌ BoardCoreDataDao get fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }

    func insert(boards: [Board]) throws {
        guard let context = boards.first?.managedObjectContext else {
            throw CoreDataError.invalidManagedObjectContext
        }
        
        do {
            try context.save()

        } catch {
            print("❌❌❌ BoardCoreDataDao insert fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }

    func delete(boards: [Board]) throws {
        guard !boards.isEmpty else {
            return
        }
        
        guard let context = boards.first?.managedObjectContext else {
            throw CoreDataError.invalidManagedObjectContext
        }
        
        do {
            for board in boards {
                context.delete(board)
            }
            try context.save()
            
        } catch {
            print("❌❌❌ BoardCoreDataDao delete fail !")
            print(error.localizedDescription)
            throw error
        }
    }
    
    func truncate() throws {
        let truncateRequest = NSBatchDeleteRequest(fetchRequest: Board.fetchRequest())
        
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        do {
            try context.execute(truncateRequest)
            try context.save()

        } catch {
            print("❌❌❌ BoardCoreDataDao truncate fail !")
            print(error.localizedDescription)
            
            throw error
        }
    }
}
