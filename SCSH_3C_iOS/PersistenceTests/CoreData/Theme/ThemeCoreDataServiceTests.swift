//
//  ThemeCoreDataServiceTests.swift
//  PersistenceTests
//
//  Created by 辜敬閎 on 2023/12/1.
//

import XCTest
import CoreData
@testable import Persistence

final class ThemeCoreDataServiceTests: XCTestCase {

    var sut: ThemeCoreDataService!

    ///
    /// Test func `saveAll` returns successfully.
    ///
    /// Expect:
    ///    1. saveResult = success
    ///
    /// Condition:
    ///    1. deleteResult = success
    ///    2. insertResult = success
    ///
    func testSaveSuccess() {
        
        let mockThemeCoreDataDao = MockThemeCoreDataDao(getResult: .failure(NSError(domain: "ignore", code: 0)),
                                                        insertResult: .success(()),
                                                        deleteResult: .success(()),
                                                        truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        // sut
        makeSUT(themeCoreDataDao: mockThemeCoreDataDao)

        let saveResult = sut.save(themes: [])
        
        switch saveResult {
        case .failure(let error):
            XCTFail(error.localizedDescription)
            
        default: break
        }
    }

    ///
    /// Test func `get(type: {type})` returns successfully.
    ///
    /// Expect:
    ///    1. count = `1`
    ///    2. Theme(id: `1`,
    ///             type: `home`,
    ///             code: `explore`)
    ///
    /// Condition:
    ///    1. getResult = success([ Theme(id: `1`,
    ///                                   type: `home`,
    ///                                   code: `explore`)])
    ///    2. type = `home`
    ///
    func testGetByTypeSuccess() {
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        // mock
        let mockTheme = get(id: 1, type: "home", code: "explore", context: context)
        
        let mockThemeCoreDataDao = MockThemeCoreDataDao(getResult: .success([mockTheme]),
                                                        insertResult: .failure(NSError(domain: "ignore", code: 0)),
                                                        deleteResult: .failure(NSError(domain: "ignore", code: 0)),
                                                        truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        // sut
        makeSUT(themeCoreDataDao: mockThemeCoreDataDao)

        let result = sut.get(type: "home")
        
        switch result {
        case .success(let themes):
            
            XCTAssertEqual(themes.count, 1)
            
            XCTAssertEqual(themes[0].id, 1)
            XCTAssertEqual(themes[0].type, "home")
            XCTAssertEqual(themes[0].code, "explore")
            
        case .failure(let error):
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
    
    private func makeSUT(themeCoreDataDao: ThemeCoreDataDaoType) {
        sut = ThemeCoreDataService(themeCoreDataDao: themeCoreDataDao)
    }
}

class MockThemeCoreDataDao: ThemeCoreDataDaoType {
    private let getResult: Result<[Persistence.Theme], Error>
    private let insertResult: Result<Void, Error>
    private let deleteResult: Result<Void, Error>
    private let truncateResult: Result<Void, Error>

    init(getResult: Result<[Persistence.Theme], Error>, insertResult: Result<Void, Error>, deleteResult: Result<Void, Error>, truncateResult: Result<Void, Error>) {
        self.getResult = getResult
        self.insertResult = insertResult
        self.deleteResult = deleteResult
        self.truncateResult = truncateResult
    }
    
    func get(type: String) throws -> [Persistence.Theme] {
        switch getResult {
        case .success(let theme):
            return theme
        case .failure(let error):
            throw error
        }
    }
    
    func insert(themes: [Persistence.Theme]) throws {
        switch insertResult {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
    
    func delete(types: [String]) throws {
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
