//
//  ThemeCoreDataDaoTests.swift
//  PersistenceTests
//
//  Created by 辜敬閎 on 2023/12/3.
//

import XCTest
import CoreData
@testable import Persistence

final class ThemeCoreDataDaoTests: XCTestCase {

    var sut: ThemeCoreDataDao!

    ///
    /// Test `teuncate Table Theme` in CoreData returns successfully.
    ///
    /// Expect:
    ///    no error be thrown.
    ///
    /// Condition:
    ///    none
    func testTruncateSuccess() throws {
        // sut
        makeSUT()
        
        do {
            try sut.truncate()

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    ///
    /// Test `insert into Theme (a, b, c) values (1, 2, 3)` returns successfully.
    ///
    /// Expect:
    ///    1. count = `3`
    ///    2. Theme(id: `1`,
    ///             type: `home`,
    ///             code: `explore`,
    ///    3. Theme(id: `2`,
    ///             type: `home`,
    ///             code: `special`,
    ///    4. Theme(id: `3`,
    ///             type: `home`,
    ///             code: `product_3C`,
    ///
    /// Condition:
    ///       Table `Board` is empty
    ///
    ///
    func testInsertSuccess() throws {
        // sut
        makeSUT()
        
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        let mockTheme_1 = get(id: 1, type: "home", code: "explore", context: context)
        let mockTheme_2 = get(id: 2, type: "home", code: "special", context: context)
        let mockTheme_3 = get(id: 3, type: "home", code: "product_3C", context: context)
        
        do {
            try sut.truncate()
            try sut.insert(themes: [mockTheme_1, mockTheme_2, mockTheme_3])
            
            let result = try sut.get(type: "home")
            
            XCTAssertEqual(result.count, 3)
            
            XCTAssertEqual(result[0].id, 1)
            XCTAssertEqual(result[0].type, "home")
            XCTAssertEqual(result[0].code, "explore")

            XCTAssertEqual(result[1].id, 2)
            XCTAssertEqual(result[1].type, "home")
            XCTAssertEqual(result[1].code, "special")

            XCTAssertEqual(result[2].id, 3)
            XCTAssertEqual(result[2].type, "home")
            XCTAssertEqual(result[2].code, "product_3C")
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    ///
    /// Test `delete from Theme where type in ('home', 'explore')` returns successfully.
    ///
    /// Expect:
    ///    1. result `select * from Theme where type in ('home', 'explore')` is empty
    ///
    /// Condition:
    ///    1. Those `themes` exist in Theme
    ///      1-1. Theme(id: `1`,
    ///              type: `home`,
    ///              code: `explore`,
    ///      1-2. Theme(id: `13`,
    ///              type: `explore`,
    ///              code: `board`,
    ///
    ///    2. type == (`home`, `explore`)
    ///
    func testDeleteSuccess() throws {
        // sut
        makeSUT()
        
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        let mockTheme_1 = get(id: 1, type: "home", code: "explore", context: context)
        let mockTheme_2 = get(id: 13, type: "explore", code: "board", context: context)
        
        do {
            try sut.truncate()
            try sut.insert(themes: [mockTheme_1, mockTheme_2])
            try sut.delete(types: ["home", "explore"])
            
            let result_1 = try sut.get(type: "home")
            XCTAssertTrue(result_1.isEmpty)
            
            let result_2 = try sut.get(type: "explore")
            XCTAssertTrue(result_2.isEmpty)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    ///
    /// Test `select * from Theme where type == 'home'` returns successfully.
    ///
    /// Expect:
    ///    1. count == `1`
    ///    2. Theme(id: `1`,
    ///             type: `home`,
    ///             code: `explore`)
    ///
    /// Condition:
    ///    1. Those `themes` exist in Theme
    ///      1-1. Theme(id: `1`,
    ///                 type: `home`,
    ///                 code: `explore`,
    ///      1-2. Theme(id: `13`,
    ///                 type: `explore`,
    ///                 code: `board`,
    ///
    ///    2. type == `home`
    ///
    func testGetByTypeSuccess() throws {
        // sut
        makeSUT()

        let context = CoreDataController.shared.container.newBackgroundContext()
        
        let mockTheme_1 = get(id: 1, type: "home", code: "explore", context: context)
        let mockTheme_2 = get(id: 13, type: "explore", code: "board", context: context)
        
        do {
            try sut.truncate()
            try sut.insert(themes: [mockTheme_1, mockTheme_2])
            let result = try sut.get(type: "home")
            
            XCTAssertEqual(result.count, 1)
            
            XCTAssertEqual(result[0].id, 1)
            XCTAssertEqual(result[0].type, "home")
            XCTAssertEqual(result[0].code, "explore")
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    
    
    private func get(id: Int64, type: String, code: String, context: NSManagedObjectContext) -> Theme {
        let theme = Theme(context: context)
        theme.id = id
        theme.type = type
        theme.code = code
        return theme
    }
    
    private func makeSUT() {
        sut = ThemeCoreDataDao()
    }
}
