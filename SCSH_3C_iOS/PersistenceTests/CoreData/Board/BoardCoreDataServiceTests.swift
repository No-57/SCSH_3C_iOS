//
//  BoardCoreDataServiceTests.swift
//  PersistenceTests
//
//  Created by 辜敬閎 on 2023/11/29.
//

import XCTest
import CoreData
@testable import Persistence

final class BoardCoreDataServiceTests: XCTestCase {

    var sut: BoardCoreDataService!
    
    ///
    /// Test func `saveAll` returns successfully.
    ///
    /// Expect:
    ///    1. saveAllResult = success
    ///
    /// Condition:
    ///    1. truncateResult = success
    ///    2. insertResult = success
    ///
    func testSaveAllSuccess() {
        let mockBoardCoreDataDao = MockBoardCoreDataDao(getResult: .failure(NSError(domain: "ignore", code: 0)),
                                                        insertResult: .success(()),
                                                        deleteResult: .failure(NSError(domain: "ignore", code: 0)),
                                                        truncateResult: .success(()))
        // sut
        sut = makeSUT(boardCoreDataDao: mockBoardCoreDataDao)

        let saveAllResult = sut.saveAll(boards: [])
        
        switch saveAllResult {
        case .failure(let error):
            XCTFail(error.localizedDescription)
            
        default: break
        }
    }
    
    ///
    /// Test func `upsert` returns successfully.
    ///
    /// Expect:
    ///    1. upsertResult = success
    ///
    /// Condition:
    ///    1. getResult = success(`empty array`)
    ///    2. insertResult = success
    ///
    func testUpsertSuccessWithGetAnsInsertSuccess() {
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        // mock
        let mockBoard = get(id: 123,
                            code: "main_carousel_board",
                            imageURL: URL(string: "https://example.com/image.jpg"),
                            actionType: "deep_ink",
                            action: "orange://main_page",
                            context: context)
        
        let mockBoardCoreDataDao = MockBoardCoreDataDao(getResult: .success([]),
                                                        insertResult: .success(()),
                                                        deleteResult: .failure(NSError(domain: "ignore", code: 0)),
                                                        truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        // sut
        sut = makeSUT(boardCoreDataDao: mockBoardCoreDataDao)

        let upsertResult = sut.upsert(board: mockBoard)
        
        switch upsertResult {
        case .failure(let error):
            XCTFail(error.localizedDescription)
            
        default: break
        }
    }
    
    ///
    /// Test func `upsert` returns successfully.
    ///
    /// Expect:
    ///    1. upsertResult = success
    ///
    /// Condition:
    ///    1. getResult = success(`not empty array`)
    ///    2. insertResult = success
    ///
    func testUpsertSuccessWithGetAndInsertAndDeleteSuccess() {
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        // mock
        let mockBoard = get(id: 123,
                            code: "main_carousel_board",
                            imageURL: URL(string: "https://example.com/image.jpg"),
                            actionType: "deep_ink",
                            action: "orange://main_page",
                            context: context)
        
        let mockBoardCoreDataDao = MockBoardCoreDataDao(getResult: .success([mockBoard]),
                                                        insertResult: .success(()),
                                                        deleteResult: .success(()),
                                                        truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        // sut
        sut = makeSUT(boardCoreDataDao: mockBoardCoreDataDao)

        let upsertResult = sut.upsert(board: mockBoard)
        
        switch upsertResult {
        case .failure(let error):
            XCTFail(error.localizedDescription)
            
        default: break
        }
    }
    
    ///
    /// Test func `get(code: {code})` returns successfully.
    ///
    /// Expect:
    ///    1. count = `1`
    ///    2. Board(id: `123`,
    ///             code: `main_carousel_board`,
    ///             image-url: `https://example.com/image.jpg`,
    ///             action: `deep_ink`,
    ///             action-type: `orange://main_page`)
    ///
    /// Condition:
    ///    1. getResult = success([ Board(id: `123`,
    ///                   			      code: `main_carousel_board`,
    ///                   			      image-url: `https://example.com/image.jpg`,
    ///                   			      action: `deep_ink`,
    ///                   			      action-type: `orange://main_page`)])
    ///    2. code = `main_carousel_board`
    ///
    func testGetByCodeSuccess() {
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        // mock
        let mockBoard_1 = get(id: 123,
                              code: "main_carousel_board",
                              imageURL: URL(string: "https://example.com/image.jpg"),
                              actionType: "deep_ink",
                              action: "orange://main_page",
                              context: context)
        
        let mockBoardCoreDataDao = MockBoardCoreDataDao(getResult: .success([mockBoard_1]),
                                                        insertResult: .failure(NSError(domain: "ignore", code: 0)),
                                                        deleteResult: .failure(NSError(domain: "ignore", code: 0)),
                                                        truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        // sut
        sut = makeSUT(boardCoreDataDao: mockBoardCoreDataDao)

        let result = sut.get(code: "main_carousel_board")
        
        switch result {
        case .success(let boards):
            
            XCTAssertEqual(boards.count, 1)
            
            XCTAssertEqual(boards[0].id, 123)
            XCTAssertEqual(boards[0].code, "main_carousel_board")
            XCTAssertEqual(boards[0].image_url, URL(string: "https://example.com/image.jpg"))
            XCTAssertEqual(boards[0].action_type, "deep_ink")
            XCTAssertEqual(boards[0].action, "orange://main_page")
            
        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }

    private func get(id: Int64, code: String, imageURL: URL?, actionType: String, action: String, context: NSManagedObjectContext) -> Board {
        let board = Board(context: context)
        board.id = id
        board.code = code
        board.image_url = imageURL
        board.action_type = actionType
        board.action = action
        
        return board
    }
    
    private func makeSUT(boardCoreDataDao: BoardCoreDataDaoType) -> BoardCoreDataService {
        BoardCoreDataService(boardCoreDataDao: boardCoreDataDao)
    }
}

class MockBoardCoreDataDao: BoardCoreDataDaoType {
    
    private let getResult: Result<[Persistence.Board], Error>
    private let insertResult: Result<Void, Error>
    private let deleteResult: Result<Void, Error>
    private let truncateResult: Result<Void, Error>
    
    init(getResult: Result<[Persistence.Board], Error>, insertResult: Result<Void, Error>, deleteResult: Result<Void, Error>, truncateResult: Result<Void, Error>) {
        self.getResult = getResult
        self.insertResult = insertResult
        self.deleteResult = deleteResult
        self.truncateResult = truncateResult
    }
    
    func get(code: String?) throws -> [Persistence.Board] {
        switch getResult {
        case .success(let board):
            return board
        case .failure(let error):
            throw error
        }
    }

    func insert(boards: [Persistence.Board]) throws {
        switch insertResult {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

    func delete(boards: [Persistence.Board]) throws {
        switch deleteResult {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

    func truncate() throws {
        switch truncateResult {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
