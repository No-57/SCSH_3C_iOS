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

protocol ExploreBoardMapperType {
    // TODO: add Network.Board transformation.
    
    func transform(from boards: [Persistence.Board]) -> [ExploreBoard]
    func transform(from exploreBoards: [ExploreBoard], context: NSManagedObjectContext) -> [Persistence.Board]
}

class ExploreBoardMapper: ExploreBoardMapperType {
    func transform(from boards: [Persistence.Board]) -> [ExploreBoard] {
        boards.map { board in
            ExploreBoard(id: String(board.id),
                         imageUrl: board.image_url,
                         action: URL(string: board.action ?? ""))
        }
    }
    
    func transform(from exploreBoards: [ExploreBoard], context: NSManagedObjectContext) -> [Persistence.Board] {
        exploreBoards.map { exploreBoard in
            let board = Persistence.Board(context: context)
            board.id = Int64(exploreBoard.id) ?? 0
            board.code = ExploreBoard.code
            board.image_url = exploreBoard.imageUrl
            board.action_type = "" // TODO: adjust `ExploreBoard` model
            board.action = exploreBoard.action?.absoluteString
            
            return board
        }
    }
}
