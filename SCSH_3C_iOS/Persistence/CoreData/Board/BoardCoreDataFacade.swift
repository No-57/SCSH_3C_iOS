//
//  BoardCoreDataFacade.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/12/1.
//

import Combine
import CoreData

public protocol BoardCoreDataFacadeType {
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

public class BoardCoreDataFacade: BoardCoreDataFacadeType {
    
    private let boardCoreDataService: BoardCoreDataServiceType = BoardCoreDataService(boardCoreDataDao: BoardCoreDataDao())
    
    public init() {}
    
    public func get(code: String?) -> AnyPublisher<[Board], Error> {
        Future<[Board], Error> { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.boardCoreDataService.get(code: code))
        }
        .eraseToAnyPublisher()
    }

    public func upsert(board: Board) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.boardCoreDataService.upsert(board: board))
        }
        .eraseToAnyPublisher()
    }

    public func saveAll(boards: [Board]) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.boardCoreDataService.saveAll(boards: boards))
        }
        .eraseToAnyPublisher()
    }
}
