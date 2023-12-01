//
//  BoardCoreDataServiceTests.swift
//  PersistenceTests
//
//  Created by 辜敬閎 on 2023/11/29.
//

import XCTest
import Combine
@testable import Persistence
import CoreData

final class BoardCoreDataServiceTests: XCTestCase {

    var sut: BoardCoreDataService!
    var cancellables = Set<AnyCancellable>()
    
    
    ///
    /// Test `insert into Board (x, x, x) values (a, b, c)` in CoreData returns successfully.
    ///
    /// Expect:
    ///    1. count = `1`
    ///    2. Board(id: `123`,
    ///             code: `main_carousel_board`,
    ///             image_url: `https://example.com/image.jpg`,
    ///             action: `deep_ink`,
    ///             action_type: `orange://main_page`)
    ///
    /// Condition:
    ///       none
    ///
    func testInsertData() {
        sut = makeSUT()
        let context = CoreDataController.shared.container.newBackgroundContext()

        let mockQueryCode = "main_carousel_board"
        let mockBoard = get(id: 123,
                            code: "main_carousel_board",
                            imageURL: URL(string: "https://example.com/image.jpg"),
                            actionType: "deep_ink",
                            action: "orange://main_page",
                            context: context)

        sut.upsert(board: mockBoard)
            .flatMap { _ -> AnyPublisher<[Board], Error> in
                self.sut.get(code: mockQueryCode)
            }
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break;
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { boards in
                XCTAssertEqual(boards.count, 1)

                XCTAssertEqual(boards[0].id, 123)
                XCTAssertEqual(boards[0].code, "main_carousel_board")
                XCTAssertEqual(boards[0].image_url, URL(string: "https://example.com/image.jpg"))
                XCTAssertEqual(boards[0].action_type, "deep_ink")
                XCTAssertEqual(boards[0].action, "orange://main_page")
            })
            .store(in: &cancellables)
    }
    
    ///
    /// Test `insert into Board (x, x, x) values (a, b, c)` in CoreData returns successfully.
    ///
    /// Expect:
    ///    1. count = `3`
    ///    2. Board(id: `123`,
    ///             code: `main_carousel_board`,
    ///             image_url: `https://example.com/image.jpg`,
    ///             action: `deep_ink`,
    ///             action_type: `orange://main_page`)
    ///    3. Board(id: `555`,
    ///             code: `main_bottom_board`,
    ///             image_url: `https://example.com/image2.jpg`,
    ///             action: `show_alert`,
    ///             action_type: `Alert`)
    ///    4. Board(id: `876`,
    ///             code: `product_list_board`,
    ///             image_url: `https://example.com/image8.jpg`,
    ///             action: `web_link`,
    ///             action_type: `https://example.com`)
    ///
    /// Condition:
    ///       none
    ///
    func testInsertAllData() {
        sut = makeSUT()
        let context = CoreDataController.shared.container.newBackgroundContext()

        let mockBoard_1 = get(id: 123,
                            code: "main_carousel_board",
                            imageURL: URL(string: "https://example.com/image.jpg"),
                            actionType: "deep_ink",
                            action: "orange://main_page",
                            context: context)
        let mockBoard_2 = get(id: 555,
                            code: "main_bottom_board",
                            imageURL: URL(string: "https://example.com/image2.jpg"),
                            actionType: "show_alert",
                            action: "Alert",
                            context: context)
        let mockBoard_3 = get(id: 876,
                            code: "product_list_board",
                            imageURL: URL(string: "https://example.com/image8.jpg"),
                            actionType: "web_link",
                            action: "https://example.com",
                            context: context)


        sut.saveAll(boards: [mockBoard_1, mockBoard_2, mockBoard_3])
            .flatMap { _ -> AnyPublisher<[Board], Error> in
                self.sut.get(code: nil)
            }
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break;
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { boards in
                XCTAssertEqual(boards.count, 3)
                
                XCTAssertEqual(boards[0].id, 123)
                XCTAssertEqual(boards[0].code, "main_carousel_board")
                XCTAssertEqual(boards[0].image_url, URL(string: "https://example.com/image.jpg"))
                XCTAssertEqual(boards[0].action_type, "deep_ink")
                XCTAssertEqual(boards[0].action, "orange://main_page")
                
                XCTAssertEqual(boards[1].id, 555)
                XCTAssertEqual(boards[1].code, "main_bottom_board")
                XCTAssertEqual(boards[1].image_url, URL(string: "https://example.com/image2.jpg"))
                XCTAssertEqual(boards[1].action_type, "show_alert")
                XCTAssertEqual(boards[1].action, "Alert")
                
                XCTAssertEqual(boards[2].id, 876)
                XCTAssertEqual(boards[2].code, "product_list_board")
                XCTAssertEqual(boards[2].image_url, URL(string: "https://example.com/image8.jpg"))
                XCTAssertEqual(boards[2].action_type, "web_link")
                XCTAssertEqual(boards[2].action, "https://example.com")

            })
            .store(in: &cancellables)
    }
    
    ///
    /// Test `Select * from Board` in CoreData returns successfully.
    ///
    /// Expect:
    ///    1. []
    ///
    /// Condition:
    ///    1. This table doesn't contain the value with code == `'This code doesn't exist.'`.
    ///
    func testGetWithoutData() {
        sut = makeSUT()

        sut.get(code: "This code doesn't exist.")
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break;
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { boards in
                XCTAssertEqual(boards.isEmpty, true)

            })
            .store(in: &cancellables)
    }
    
    ///
    /// Test `Select * from Board` in CoreData returns successfully.
    ///
    /// Expect:
    ///    1. Board(id: `123`,
    ///             code: `main_carousel_board`,
    ///             image_url: `https://example.com/image.jpg`,
    ///             action: `deep_ink`,
    ///             action_type: `orange://main_page`)
    ///
    /// Condition:
    ///    1. This data have already existed in the table Product.
    ///    2. query: `code == main_carousel_board`
    ///
    func testGetByCode() {
        sut = makeSUT()
        let context = CoreDataController.shared.container.newBackgroundContext()

        let mockQueryCode = "main_carousel_board"
        let mockBoard = get(id: 123,
                            code: "main_carousel_board",
                            imageURL: URL(string: "https://example.com/image.jpg"),
                            actionType: "deep_ink",
                            action: "orange://main_page",
                            context: context)


        sut.upsert(board: mockBoard)
            .flatMap { _ -> AnyPublisher<[Board], Error> in
                self.sut.get(code: mockQueryCode)
            }
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break;
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { boards in
                XCTAssertEqual(boards.count, 1)
                XCTAssertEqual(boards[0].id, 123)
                XCTAssertEqual(boards[0].code, "main_carousel_board")
                XCTAssertEqual(boards[0].image_url, URL(string: "https://example.com/image.jpg"))
                XCTAssertEqual(boards[0].action_type, "deep_ink")
                XCTAssertEqual(boards[0].action, "orange://main_page")

            })
            .store(in: &cancellables)
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
    
    private func makeSUT() -> BoardCoreDataService {
        BoardCoreDataService()
    }
}
