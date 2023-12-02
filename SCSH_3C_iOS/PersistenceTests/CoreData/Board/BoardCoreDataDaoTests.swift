//
//  BoardCoreDataDaoTests.swift
//  PersistenceTests
//
//  Created by 辜敬閎 on 2023/12/2.
//

import XCTest
import CoreData
@testable import Persistence

final class BoardCoreDataDaoTests: XCTestCase {

//    func get(code: String?) throws -> [Board]
//
//    func delete(boards: [Board]) throws
//
    
    var sut: BoardCoreDataDao!

    ///
    /// Test `TRUNCATE Table Board` in CoreData returns successfully.
    ///
    /// Expect:
    ///    1. count = `0`
    ///
    /// Condition:
    ///    none
    func testTruncateSuccess() throws {
        // sut
        makeSUT()
        
        do {
            try sut.truncate()
            let boards = try sut.get(code: nil)
            
            XCTAssertEqual(boards.isEmpty, true)

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    ///
    /// Test `insert into Board (x, x, x) values (a, b, c)` in CoreData returns successfully.
    ///
    /// Expect:
    ///    1. count = `3`
    ///    2. Board(id: `123`,
    ///             code: `main_carousel_board`,
    ///             image-url: `https://example.com/image.jpg`,
    ///             action: `deep_ink`,
    ///             action-type: `orange://main_page`)
    ///    3. Board(id: `555`,
    ///             code: `main_bottom_board`,
    ///             image-url: `https://example.com/image2.jpg`,
    ///             action: `show_alert`,
    ///             action-type: `Alert`)
    ///    4. Board(id: `876`,
    ///             code: `product_list_board`,
    ///             image-url: `https://example.com/image8.jpg`,
    ///             action: `web_link`,
    ///             action-type: `https://example.com`)
    ///
    /// Condition:
    ///       Table `Board` is empty
    ///
    func testInsertSuccess() {
        // sut
        makeSUT()
        
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

        do {
            try sut.truncate()
            try sut.insert(boards: [mockBoard_1, mockBoard_2, mockBoard_3])
            let boards = try sut.get(code: nil)

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
        } catch {
            XCTFail(error.localizedDescription)
        }

    }
    
    ///
    /// Test `delete from board` in CoreData returns successfully.
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
    ///    Table already exist those data.
    ///      1. Board(id: `123`,
    ///               code: `main_carousel_board`,
    ///               image-url: `https://example.com/image.jpg`,
    ///               action: `deep_ink`,
    ///               action-type: `orange://main_page`)
    ///     2. Board(id: `555`,
    ///              code: `main_bottom_board`,
    ///              image-url: `https://example.com/image2.jpg`,
    ///              action: `show_alert`,
    ///              action-type: `Alert`)
    ///     3. Board(id: `876`,
    ///              code: `product_list_board`,
    ///              image-url: `https://example.com/image8.jpg`,
    ///              action: `web_link`,
    ///              action-type: `https://example.com`)
    ///
    func testDeleteSuccess() {
        // sut
        makeSUT()
        
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

        do {
            try sut.truncate()
            try sut.insert(boards: [mockBoard_1, mockBoard_2, mockBoard_3])
            try sut.delete(boards: [mockBoard_2, mockBoard_3])
            let boards = try sut.get(code: nil)

            XCTAssertEqual(boards.count, 1)
            
            XCTAssertEqual(boards[0].id, 123)
            XCTAssertEqual(boards[0].code, "main_carousel_board")
            XCTAssertEqual(boards[0].image_url, URL(string: "https://example.com/image.jpg"))
            XCTAssertEqual(boards[0].action_type, "deep_ink")
            XCTAssertEqual(boards[0].action, "orange://main_page")
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    ///
    /// Test `Select * from Board where code == {code}` in CoreData returns successfully.
    ///
    /// Expect:
    ///    1. count = 2
    ///    2. Board(id: `123`,
    ///             code: `main_carousel_board`,
    ///             image-url: `https://example.com/image.jpg`,
    ///             action: `deep_ink`,
    ///             action-type: `orange://main_page`)
    ///    3. Board(id: `555`,
    ///             code: `main_carousel_board`,
    ///             image-url: `https://example.com/image2.jpg`,
    ///             action: `show_alert`,
    ///             action-type: `Alert`)
    ///
    /// Condition:
    ///    1. Table already exist those data.
    ///      1. Board(id: `123`,
    ///               code: `main_carousel_board`,
    ///               image-url: `https://example.com/image.jpg`,
    ///               action: `deep_ink`,
    ///               action-type: `orange://main_page`)
    ///      2. Board(id: `555`,
    ///               code: `main_carousel_board`,
    ///               image-url: `https://example.com/image2.jpg`,
    ///               action: `show_alert`,
    ///               action-type: `Alert`)
    ///      3. Board(id: `876`,
    ///               code: `product_list_board`,
    ///               image-url: `https://example.com/image8.jpg`,
    ///               action: `web_link`,
    ///               action-type: `https://example.com`)
    ///
    ///    2. query: `code == main_carousel_board`
    ///
    func testGetWithCodeSuccess() {
        // sut
        makeSUT()
        
        let context = CoreDataController.shared.container.newBackgroundContext()

        let mockBoard_1 = get(id: 123,
                            code: "main_carousel_board",
                            imageURL: URL(string: "https://example.com/image.jpg"),
                            actionType: "deep_ink",
                            action: "orange://main_page",
                            context: context)
        let mockBoard_2 = get(id: 555,
                            code: "main_carousel_board",
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
        
        do {
            try sut.truncate()
            try sut.insert(boards: [mockBoard_1, mockBoard_2, mockBoard_3])
            let boards = try sut.get(code: "main_carousel_board")

            XCTAssertEqual(boards.count, 2)
            
            XCTAssertEqual(boards[0].id, 123)
            XCTAssertEqual(boards[0].code, "main_carousel_board")
            XCTAssertEqual(boards[0].image_url, URL(string: "https://example.com/image.jpg"))
            XCTAssertEqual(boards[0].action_type, "deep_ink")
            XCTAssertEqual(boards[0].action, "orange://main_page")
            
            XCTAssertEqual(boards[1].id, 555)
            XCTAssertEqual(boards[1].code, "main_carousel_board")
            XCTAssertEqual(boards[1].image_url, URL(string: "https://example.com/image2.jpg"))
            XCTAssertEqual(boards[1].action_type, "show_alert")
            XCTAssertEqual(boards[1].action, "Alert")
            
        } catch {
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
    
    private func makeSUT() {
        sut = BoardCoreDataDao()
    }
}
