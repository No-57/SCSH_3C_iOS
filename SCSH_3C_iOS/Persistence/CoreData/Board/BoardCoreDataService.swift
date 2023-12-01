//
//  BoardCoreDataService.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/11/29.
//

import Combine
import CoreData

public protocol BoardCoreDataServiceType {
    func get(code: String?) -> AnyPublisher<[Board], Error>
    
    ///
    /// if data exists then update, otherwise insert.
    ///
    func upsert(board: Board) -> AnyPublisher<Void, Error>
    
    ///
    /// truncate and then insert.
    ///
    func saveAll(boards: [Board]) -> AnyPublisher<Void, Error>
}

public class BoardCoreDataService: BoardCoreDataServiceType {
    
    public init() {}
    
    public func get(code: String?) -> AnyPublisher<[Board], Error> {
        Future<[Board], Error> { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.get(code: code))
        }
        .eraseToAnyPublisher()
    }

    public func upsert(board: Board) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.upsert(board: board))
        }
        .eraseToAnyPublisher()
    }

    public func saveAll(boards: [Board]) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.saveAll(boards: boards))
        }
        .eraseToAnyPublisher()
    }
    
    private func get(code: String?, context: NSManagedObjectContext = CoreDataController.shared.container.newBackgroundContext()) -> Result<[Board], Error> {
        let fetchRequest = Board.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        if let code = code {
            fetchRequest.predicate = NSPredicate(format: "code == %@", code)
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            try context.save()
            
            return .success(results)
            
        } catch {
            return .failure(error)
        }
    }
    
    private func upsert(board: Board) -> Result<Void, Error> {
        guard let code = board.code else {
            // TODO: Error handling
            return .failure(NSError(domain: "", code: 0))
        }
        let context = board.managedObjectContext ?? CoreDataController.shared.container.newBackgroundContext()
        let result: Result<[Board], Error> = get(code: code)

        switch result {
        case .success(let existingBoards):
            
            if let existingBoard = existingBoards.first {
                update(existingBoard: existingBoard, newBoard: board)
                context.delete(board)
            } else {
                context.insert(board)
            }

            do {
                try context.save()

                return .success(())
            } catch {
                print("❌❌❌ BoardCoreDataService saveAll save fail !")
                print(error.localizedDescription)

                return .failure(error)
            }
            
        case .failure(let error):
            print("❌❌❌ BoardCoreDataService saveAll get fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
    
    private func update(existingBoard: Board, newBoard: Board) {
        existingBoard.id = newBoard.id
        existingBoard.code = newBoard.code
        existingBoard.action_type = newBoard.action_type
        existingBoard.action = newBoard.action
        existingBoard.image_url = newBoard.image_url
    }
    
    private func saveAll(boards: [Board]) -> Result<Void, Error> {
        
        let context = boards.first?.managedObjectContext ?? CoreDataController.shared.container.newBackgroundContext()
        
        truncate(context: context)

        do {
            try context.save()

            return .success(())
            
        } catch {
            print("❌❌❌ BoardCoreDataService saveAll fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
    
    private func truncate(context: NSManagedObjectContext) {
        let truncateRequest = NSBatchDeleteRequest(fetchRequest: Board.fetchRequest())
        
        do {
            try context.execute(truncateRequest)
            try context.save()

        } catch {
            print("❌❌❌ BoardCoreDataService truncate fail !")
            print(error.localizedDescription)
        }
    }
}

