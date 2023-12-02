//
//  BoardCoreDataService.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/11/29.
//

import Combine
import CoreData

public protocol BoardCoreDataServiceType {
    func get(code: String?) -> Result<[Board], Error>
    
    ///
    /// if data exists then update, otherwise insert.
    ///
    func upsert(board: Board) -> Result<Void, Error>
    
    ///
    /// truncate and then insert.
    ///
    func saveAll(boards: [Board]) -> Result<Void, Error>
}

class BoardCoreDataService: BoardCoreDataServiceType {
    
    private let boardCoreDataDao: BoardCoreDataDaoType
    
    init(boardCoreDataDao: BoardCoreDataDaoType) {
        self.boardCoreDataDao = boardCoreDataDao
    }
    
    func get(code: String?) -> Result<[Board], Error> {
        do {
            let result = try boardCoreDataDao.get(code: code)
            
            return .success(result)
            
        } catch {
            print("❌❌❌ BoardCoreDataService get fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
    
    func upsert(board: Board) -> Result<Void, Error> {
        guard let code = board.code else {
            return .failure(CoreDataError.invalidProperty)
        }
        
        do {
            let result = try boardCoreDataDao.get(code: code)
            
            if !result.isEmpty {
                try boardCoreDataDao.delete(boards: result)
            }

            try boardCoreDataDao.insert(boards: [board])
                
            return .success(())
        } catch {
            print("❌❌❌ BoardCoreDataService upsert fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
    
    func saveAll(boards: [Board]) -> Result<Void, Error> {
        do {
            try boardCoreDataDao.truncate()
            try boardCoreDataDao.insert(boards: boards)

            return .success(())
            
        } catch {
            print("❌❌❌ BoardCoreDataService saveAll fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
}
