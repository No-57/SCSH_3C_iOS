//
//  DistributorLikeCoreDataDaoTests.swift
//  PersistenceTests
//
//  Created by 辜敬閎 on 2023/12/6.
//

import XCTest
import CoreData
@testable import Persistence

final class DistributorLikeCoreDataDaoTests: XCTestCase {

    var sut: DistributorLikeCoreDataDao!

    ///
    /// Test `teuncate Table Distributor_Like` in CoreData returns successfully.
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
    /// Test `delete from Table Distributor_Like where id == {id}` in CoreData returns successfully.
    ///
    /// Expect:
    ///    no error be thrown.
    ///
    /// Condition:
    ///    none
    func testDeleteSuccess() throws {
        // sut
        makeSUT()
        
        do {
            try sut.delete(id: Int64(1))

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    ///
    /// Test `insert into Distributor_Like (a, b, c) values (1, 2, 3)` returns successfully.
    ///
    /// Expect:
    ///       id = `55`
    ///
    /// Condition:
    ///       Table `Distributor_Like` is empty
    ///
    func testInsertLikeIdSuccess() throws {
        // sut
        makeSUT()

        do {
            try sut.truncate()
            try sut.insert(id: Int64(55))

            let result = try sut.get(id: nil)

            XCTAssertEqual(result.count, 1)

            XCTAssertEqual(result[0].id, 55)

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    ///
    /// Test `insert into Distributor_Like (a, b, c) values (1, 2, 3)` returns successfully.
    ///
    /// Expect:
    ///    1. count = `3`
    ///    2. `mockDistributorLike_1`,
    ///    3. `mockDistributorLike_2`,
    ///    4. `mockDistributorLike_3`,
    ///
    /// Condition:
    ///       Table `Distributor_Like` is empty
    ///
    func testInsertLikesSuccess() throws {
        // sut
        makeSUT()

        let context = CoreDataController.shared.container.newBackgroundContext()

        let mockDistributorLike_1 = get(id: 1,
                                    context: context)
        let mockDistributorLike_2 = get(id: 2,
                                    context: context)
        let mockDistributorLike_3 = get(id: 3,
                                    context: context)

        do {
            try sut.truncate()
            try sut.insert(likes: [mockDistributorLike_1, mockDistributorLike_2, mockDistributorLike_3])

            let result = try sut.get(id: nil)

            XCTAssertEqual(result.count, 3)

            XCTAssertEqual(result[0].id, 1)
            XCTAssertEqual(result[1].id, 2)
            XCTAssertEqual(result[2].id, 3)

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    ///
    /// Test `select * from Distributor_Like where id == {id}` returns successfully.
    ///
    /// Expect:
    ///    1. count = `3`
    ///    2. `mockDistributorLike_1`,
    ///    3. `mockDistributorLike_2`,
    ///    4. `mockDistributorLike_3`,
    ///
    /// Condition:
    ///       Table `Distributor_Like` is empty
    ///
    ///
    func testGetByIdSuccess() throws {
        // sut
        makeSUT()

        let context = CoreDataController.shared.container.newBackgroundContext()

        let mockDistributorLike_1 = get(id: 1,
                                    context: context)
        let mockDistributorLike_2 = get(id: 2,
                                    context: context)
        let mockDistributorLike_3 = get(id: 3,
                                    context: context)

        do {
            try sut.truncate()
            try sut.insert(likes: [mockDistributorLike_1, mockDistributorLike_2, mockDistributorLike_3])

            let result = try sut.get(id: 1)

            XCTAssertEqual(result.count, 1)

            XCTAssertEqual(result[0].id, 1)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    
    private func get(id: Int64, context: NSManagedObjectContext) -> Distributor_Like {
        let like = Distributor_Like(context: context)
        like.id = id
        
        return like
    }
    
    private func makeSUT() {
        sut = DistributorLikeCoreDataDao()
    }
}
