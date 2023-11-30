//
//  BoardRepository.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/22.
//

import Foundation
import Combine
import Persistence

protocol BoardRepositoryType {
    func getExploreBoards(isLatest: Bool) -> AnyPublisher<[ExploreBoard], Error>
}

class BoardRepository: BoardRepositoryType {
    
    private let mapper: ExploreBoardMapperType
    private let boardCoreDataService: BoardCoreDataServiceType
    
    private let coreDataBackgroundContext = Persistence.CoreDataController.shared.container.newBackgroundContext()

    init(boardCoreDataService: BoardCoreDataServiceType, mapper: ExploreBoardMapperType) {
        self.mapper = mapper
        self.boardCoreDataService = boardCoreDataService
    }

    func getExploreBoards(isLatest: Bool) -> AnyPublisher<[ExploreBoard], Error> {
        if isLatest {
            return fetchExploreBoards()
                .flatMap { [weak self] _ -> AnyPublisher<[ExploreBoard], Error> in
                    guard let self = self else {
                        return Empty<[ExploreBoard], Error>().eraseToAnyPublisher()
                    }
                    
                    return self.getExploreBoards()
                }
                .eraseToAnyPublisher()
        } else {
            return getExploreBoards()
        }
    }
    
    private func getExploreBoards() -> AnyPublisher<[ExploreBoard], Error> {
        boardCoreDataService.get(code: ExploreBoard.code)
            .compactMap { [weak self] boards -> [ExploreBoard]? in
                guard let self = self else {
                    return nil
                }
                
                return self.mapper.transform(from: boards)
            }
            .eraseToAnyPublisher()
    }
    
    // TODO: API integration is required.
    
    ///
    /// ```
    /// GET https://{domainhost}/boards
    /// ?code={code}&limit={limit}`
    /// ```
    ///
    /// Response: {
    /// ```
    ///     "data": [
    ///         { "id": ...,
    ///           "image_url": ...,
    ///           "action": ...},
    ///     ]
    /// ```
    /// }
    ///
    private func fetchExploreBoards() -> AnyPublisher<Void, Error> {
        Future { promise in
            promise(.success([
                // TODO: Use Network.Board Model instead.
                ExploreBoard(id: "山跟海",
                      imageUrl: URL(string: "https://images.pexels.com/photos/15484171/pexels-photo-15484171/free-photo-of-a-black-and-white-photo-of-the-ocean.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                      action: URL(string: "https://images.pexels.com/photos/15484171/pexels-photo-15484171/free-photo-of-a-black-and-white-photo-of-the-ocean.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")),
                
                ExploreBoard(id: "發光的車",
                      imageUrl: URL(string: "https://images.pexels.com/photos/18395712/pexels-photo-18395712/free-photo-of-bmw-e30-parked-on-the-desert.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                      action: nil),
                
                ExploreBoard(id: "時鐘",
                      imageUrl: URL(string: "https://cdn.pixabay.com/photo/2023/10/18/15/43/compass-8324516_1280.jpg"),
                      action: URL(string: "https://cdn.pixabay.com/photo/2023/10/18/15/43/compass-8324516_1280.jpg")),
                
                ExploreBoard(id: "隧道",
                      imageUrl: URL(string: "https://cdn.pixabay.com/photo/2023/10/03/07/46/hamburg-8290719_1280.jpg"),
                      action: URL(string: "https://cdn.pixabay.com/photo/2023/10/03/07/46/hamburg-8290719_1280.jpg")),
                
                ExploreBoard(id: "鴨頭",
                      imageUrl: URL(string: "https://cdn.pixabay.com/photo/2023/08/29/19/42/goose-8222013_1280.jpg"),
                      action: nil),
            ]))
        }
        .compactMap { [weak self] boards -> [Persistence.Board]? in
            guard let self = self else {
                return nil
            }
            
            return self.mapper.transform(from: boards, context: self.coreDataBackgroundContext)
        }
        .flatMap { [weak self] boards -> AnyPublisher<Void, Error> in
            guard let self = self else {
                return Empty<Void, Error>().eraseToAnyPublisher()
            }
            
            return self.boardCoreDataService.saveAll(boards: boards)
        }
        .eraseToAnyPublisher()
    }
}
