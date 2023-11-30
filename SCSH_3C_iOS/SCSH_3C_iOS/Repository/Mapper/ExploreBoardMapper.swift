//
//  ExploreBoardMapper.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/11/30.
//

import Foundation
import Combine
import Persistence
import CoreData
import Networking

protocol ExploreBoardMapperType {
    func transform(networkBoards boards: [Networking.Board], context: NSManagedObjectContext) -> [Persistence.Board]
    func transform(persistenceBaords boards: [Persistence.Board]) -> [ExploreBoard]
}

class ExploreBoardMapper: ExploreBoardMapperType {
    func transform(persistenceBaords boards: [Persistence.Board]) -> [ExploreBoard] {
        boards.map { board in
            ExploreBoard(id: String(board.id),
                         imageUrl: board.image_url,
                         actionType: board.action_type,
                         action: URL(string: board.action ?? ""))
        }
    }
    
    func transform(networkBoards boards: [Networking.Board], context: NSManagedObjectContext) -> [Persistence.Board] {
        boards.map { board in
            let persistenceBoard = Persistence.Board(context: context)
            persistenceBoard.id = Int64(board.id)
            persistenceBoard.code = board.code
            persistenceBoard.image_url = URL(string: board.imageUrl)
            persistenceBoard.action_type = board.actionType
            persistenceBoard.action = board.action
            
            return persistenceBoard
        }
    }
}
