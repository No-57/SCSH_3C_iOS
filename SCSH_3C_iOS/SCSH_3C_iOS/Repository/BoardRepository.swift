//
//  BoardRepository.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/22.
//

import Foundation
import Combine
import Persistence
import Networking

protocol BoardRepositoryType {
    func getExploreBoards(isLatest: Bool) -> AnyPublisher<[ExploreBoard], Error>
}

class BoardRepository: BoardRepositoryType {
    
    private let mapper: ExploreBoardMapperType
    private let boardCoreDataFacade: BoardCoreDataFacadeType
    private let moyaNetworkFacade: MoyaNetworkFacadeType
    
    private let coreDataBackgroundContext = Persistence.CoreDataController.shared.container.newBackgroundContext()

    init(boardCoreDataFacade: BoardCoreDataFacadeType, moyaNetworkFacade: MoyaNetworkFacadeType, mapper: ExploreBoardMapperType) {
        self.mapper = mapper
        self.boardCoreDataFacade = boardCoreDataFacade
        self.moyaNetworkFacade = moyaNetworkFacade
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
        }
        
        return getExploreBoards()
    }
    
    private func getExploreBoards() -> AnyPublisher<[ExploreBoard], Error> {
        boardCoreDataFacade.get(code: ExploreBoard.code)
            .compactMap { [weak self] boards -> [ExploreBoard]? in
                guard let self = self else {
                    return nil
                }
                
                return self.mapper.transform(persistenceBaords: boards)
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchExploreBoards() -> AnyPublisher<Void, Error> {
        // TODO: Use `fetch` when API `/boards` is ready
        moyaNetworkFacade.stubFetch(apiInterface: BoardApiInterface(code: ExploreBoard.code))
            .map(\.data)
            .compactMap { [weak self] boards -> [Persistence.Board]? in
                guard let self = self else {
                    return nil
                }
                
                return self.mapper.transform(networkBoards: boards, context: self.coreDataBackgroundContext)
            }
            .flatMap { [weak self] boards -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }
                
                return self.boardCoreDataFacade.saveAll(boards: boards)
            }
            .eraseToAnyPublisher()
    }
}
