//
//  BoardRepositoryTests.swift
//  SCSH_3C_iOSTests
//
//  Created by 辜敬閎 on 2023/11/30.
//

import XCTest
import Combine
import Persistence
import Networking
import CoreData
@testable import SCSH_3C_iOS

final class BoardRepositoryTests: XCTestCase {

    var sut: BoardRepository!
    var cancellables = Set<AnyCancellable>()

    ///
    /// Test get `Board` from persistence datasource returns successfully.
    ///
    /// Expect:
    ///     1. count = 2
    ///     2. ExploreBoard(id: "123", imageUrl: URL(string: "https:example.example.jpg"), actionType: "web_link", action: URL(string: "https://example.open_product"))
    ///     3. ExploreBoard(id: "456", imageUrl: URL(string: "https:example.example2.jpg"), actionType: "web_link", action: URL(string: "https://example.open_product2"))
    ///
    /// Condition:
    ///     1. function parameters          -> isLatest: `false`
    ///
    ///     2. MockProductMapper            -> mockExploreBoards: `[`ExploreBoard(id: `123`,
    ///                                       						              imageUrl: `"https:example.example.jpg"`,
    ///                                       						              actionType: `"web_link"`,
    ///                                       						              action: `"https://example.open_product"`),`
    ///                                       						 ExploreBoard(id: `456`,
    ///                                       						              imageUrl: `"https:example.example2.jpg"`,
    ///                                       						              actionType: `"web_link"`,
    ///                                       						              action: `"https://example.open_product2"`)`]`
    ///
    ///     3. MockBoardCoreDataService     -> mockGetResult: .success(`[`Persistence.Board(id: `123`,
    ///                                                                                     code: `"explore_carousel_board"`,
    ///                                                          						    image-url: `"https:example.example2.jpg"`,
    ///                                                          						    action-type: `"web_link"`,
    ///                                                          					        action: `"https://example.open_product2"`)`,
    ///                                                                   Persistence.Board(id: `456`,
    ///                                                                                     code: `"explore_carousel_board"`,
    ///                                                                                     image-url: `"https:example.example2.jpg"`,
    ///                                                                                     action-type: `"web_link"`,
    ///                                                                                     action: `"https://example.open_product2"`)`]`
    ///
    ///
    func testGetExploreBoardSuccess() throws {
        // sut
        let mockExploreBaords = [ExploreBoard(id: "123", imageUrl: URL(string: "https:example.example.jpg"), actionType: "web_link", action: URL(string: "https://example.open_product")),
                                 ExploreBoard(id: "456", imageUrl: URL(string: "https:example.example2.jpg"), actionType: "web_link", action: URL(string: "https://example.open_product2"))]
        let mockBoardCoreData = [makeMockCoreDataModel(id: "123", imageURL: "https:example.example.jpg", actionType: "web_link", action: "https://example.open_product"),
                                   makeMockCoreDataModel(id: "456", imageURL: "https:example.example2.jpg", actionType: "web_link", action: "https://example.open_product2")]
        
        let mockBoardMapper = MockExploreBoardMapper(mockExploreBoards: mockExploreBaords, mockPersistenceBoards: [])
        let mockBoardCoreDataService = MockBoardCoreDataService(getResult: .success(mockBoardCoreData),
                                                                upsertResult: .failure(NSError(domain: "Ignore", code: 0)),
                                                                saveAllResult: .failure(NSError(domain: "Ignore", code: 0)))
        
        let receiveValueIsCalled = XCTestExpectation(description: "receiveValueIsCalled")
        makeSUT(boardCoreDataService: mockBoardCoreDataService,
                moyaNetworkFacade: MockMoyaNetworkFacade_Board(fetchResult: .failure(NSError(domain: "Ignore", code: 0))),
                mapper: mockBoardMapper)
        
        sut.getExploreBoards(isLatest: false)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTFail()
                    
                case .finished:
                    break
                }
            }, receiveValue: { boards in
                receiveValueIsCalled.fulfill()
                XCTAssertEqual(boards.count, 2)
                
                XCTAssertEqual(boards[0].id, "123")
                XCTAssertEqual(boards[0].imageUrl, URL(string: "https:example.example.jpg"))
                XCTAssertEqual(boards[0].actionType, "web_link")
                XCTAssertEqual(boards[0].action, URL(string: "https://example.open_product"))
                
                XCTAssertEqual(boards[1].id, "456")
                XCTAssertEqual(boards[1].imageUrl, URL(string: "https:example.example2.jpg"))
                XCTAssertEqual(boards[1].actionType, "web_link")
                XCTAssertEqual(boards[1].action, URL(string: "https://example.open_product2"))
            })
            .store(in: &cancellables)
        
        wait(for: [receiveValueIsCalled], timeout: 1.0)
    }

    ///
    /// Test get `Board` from Networking datasource returns successfully.
    ///
    /// Expect:
    ///     1. count = 2
    ///     2. ExploreBoard(id: "123", imageUrl: URL(string: "https:example.example.jpg"), actionType: "web_link", action: URL(string: "https://example.open_product"))
    ///     3. ExploreBoard(id: "456", imageUrl: URL(string: "https:example.example2.jpg"), actionType: "web_link", action: URL(string: "https://example.open_product2"))
    ///
    /// Condition:
    ///     1. function parameters          -> isLatest: `true`
    ///
    ///     2. MockProductMapper            -> mockExploreBoards: `[`ExploreBoard(id: `123`,
    ///                                                                           imageUrl: `"https:example.example.jpg"`,
    ///                                                                           actionType: `"web_link"`,
    ///                                                                           action: `"https://example.open_product"`),`
    ///                                                              ExploreBoard(id: `456`,
    ///                                                                           imageUrl: `"https:example.example2.jpg"`,
    ///                                                                           actionType: `"web_link"`,
    ///                                                                           action: `"https://example.open_product2"`)`]`
    ///
    ///     3. MockMoyaNetworkFacade        -> fetchResult: `[`Networking.Board(id: `123`,
    ///                                                         		        code: `"explore_carousel_board"`,
    ///                                                         		        imageUrl: `"https:example.example.jpg"`,
    ///                                                         		        actionType: `"web_link"`,
    ///                                                         		        action: `"https://example.open_product"`),`
    ///                                                        Networking.Board(id: `456`,
    ///                                                         		        code: `"explore_carousel_board"`,
    ///                                                         		        imageUrl: `"https:example.example2.jpg"`,
    ///                                                         		        actionType: `"web_link"`,
    ///                                                         		        action: `"https://example.open_product2"`)`]`
    ///
    ///     4. MockBoardCoreDataService     -> mockGetResult: .success(`[`Persistence.Board(id: `123`,
    ///                                                                                     code: `"explore_carousel_board"`,
    ///                                                                                      image-url: `"https:example.example2.jpg"`,
    ///                                                                                      action-type: `"web_link"`,
    ///                                                                                      action: `"https://example.open_product2"`)`,
    ///                                                                   Persistence.Board(id: `456`,
    ///                                                                                     code: `"explore_carousel_board"`,
    ///                                                                                     image-url: `"https:example.example2.jpg"`,
    ///                                                                                     action-type: `"web_link"`,
    ///                                                                                     action: `"https://example.open_product2"`)`]`
    ///                                        saveAllResult: .success(`()`)
    ///
    ///
    func testfetchExploreBoardSuccess() {
        // TODO: impelement after Api is ready.
    }
    
    private func makeSUT(boardCoreDataService: BoardCoreDataServiceType, moyaNetworkFacade: MoyaNetworkFacadeType, mapper: ExploreBoardMapperType) {
       sut = BoardRepository(boardCoreDataService: boardCoreDataService, moyaNetworkFacade: moyaNetworkFacade, mapper: mapper)
    }
    
    private func makeMockCoreDataModel(id: String, imageURL: String, actionType: String, action: String) -> Persistence.Board {
        let board = Persistence.Board(context: CoreDataController.shared.container.viewContext)
        board.id = Int64(id) ?? 0
        board.code = "explore_carousel_board"
        board.image_url = URL(string: imageURL)
        board.action_type = actionType
        board.action = action
        
        return board
    }
    
}

class MockBoardCoreDataService: BoardCoreDataServiceType {
    
    private let getResult: Result<[Persistence.Board], Error>
    private let upsertResult: Result<Void, Error>
    private let saveAllResult: Result<Void, Error>
    
    init(getResult: Result<[Persistence.Board], Error>, upsertResult: Result<Void, Error>, saveAllResult: Result<Void, Error>) {
        self.getResult = getResult
        self.upsertResult = upsertResult
        self.saveAllResult = saveAllResult
    }
    
    func get(code: String?) -> AnyPublisher<[Persistence.Board], Error> {
        Future { promise in
            promise(self.getResult)
        }
        .eraseToAnyPublisher()
    }
    
    func upsert(board: Persistence.Board) -> AnyPublisher<Void, Error> {
        Future { promise in
            promise(self.upsertResult)
        }
        .eraseToAnyPublisher()
    }
    
    func saveAll(boards: [Persistence.Board]) -> AnyPublisher<Void, Error> {
        Future { promise in
            promise(self.saveAllResult)
        }
        .eraseToAnyPublisher()
    }
}

class MockMoyaNetworkFacade_Board: MoyaNetworkFacadeType {
    private let fetchResult: Result<[Networking.Board], Error>
    
    init(fetchResult: Result<[Networking.Board], Error>) {
        self.fetchResult = fetchResult
    }
    
    func fetch<T>(apiInterface: T) -> AnyPublisher<T.OutputModel, Error> where T : Networking.MoyaApiInterfaceType {
        Future { promise in
            switch self.fetchResult {
            case .success(let apiModel):
                promise(.success(apiModel as! T.OutputModel))
            case .failure(let error):
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

class MockExploreBoardMapper: ExploreBoardMapperType {
    private let mockExploreBoards: [SCSH_3C_iOS.ExploreBoard]
    private let mockPersistenceBoards: [Persistence.Board]

    init(mockExploreBoards: [SCSH_3C_iOS.ExploreBoard], mockPersistenceBoards: [Persistence.Board]) {
        self.mockExploreBoards = mockExploreBoards
        self.mockPersistenceBoards = mockPersistenceBoards
    }
    
    func transform(networkBoards boards: [Networking.Board], context: NSManagedObjectContext) -> [Persistence.Board] {
        mockPersistenceBoards
    }
    
    func transform(persistenceBaords boards: [Persistence.Board]) -> [SCSH_3C_iOS.ExploreBoard] {
        mockExploreBoards
    }
}
