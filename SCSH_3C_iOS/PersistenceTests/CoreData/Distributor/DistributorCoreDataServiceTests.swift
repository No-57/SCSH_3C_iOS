//
//  DistributorCoreDataServiceTests.swift
//  PersistenceTests
//
//  Created by 辜敬閎 on 2023/12/6.
//

import XCTest
import CoreData
@testable import Persistence

final class DistributorCoreDataServiceTests: XCTestCase {

    var sut: DistributorCoreDataService!

    ///
    /// Test func `save(distributors: [Distributor])` returns successfully.
    ///
    /// Expect:
    ///    1. saveResult = success
    ///
    /// Condition:
    ///    1. Distributor insertResult, truncateResult = success
    ///
    func testSaveDistributorsSuccess() {
        let mockDistributorCoreDataDao = MockDistributorCoreDataDao(getResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                    insertResult: .success(()),
                                                                    truncateResult: .success(()))
        
        let mockDistributorLikeCoreDataDao = MockDistributorLikeCoreDataDao(getResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            deleteResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            insertLikesResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            insertLikeIdResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        // sut
        makeSUT(distributorCoreDataDao: mockDistributorCoreDataDao, distributorLikeCoreDataDao: mockDistributorLikeCoreDataDao)

        let saveResult = sut.save(distributors: [])

        switch saveResult {
        case .failure(let error):
            XCTFail(error.localizedDescription)

        default: break
        }
    }
    
    ///
    /// Test func `save(likes: [Distributor_like])` returns successfully.
    ///
    /// Expect:
    ///    1. saveResult = success
    ///
    /// Condition:
    ///    1. Distributor-Like insertResult, truncateResult = success
    ///
    func testSaveLikesSuccess() {
        let mockDistributorCoreDataDao = MockDistributorCoreDataDao(getResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                    insertResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                    truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        
        let mockDistributorLikeCoreDataDao = MockDistributorLikeCoreDataDao(getResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            deleteResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            insertLikesResult: .success(()),
                                                                            insertLikeIdResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            truncateResult: .success(()))
        // sut
        makeSUT(distributorCoreDataDao: mockDistributorCoreDataDao, distributorLikeCoreDataDao: mockDistributorLikeCoreDataDao)

        let saveResult = sut.save(likes: [])

        switch saveResult {
        case .failure(let error):
            XCTFail(error.localizedDescription)

        default: break
        }
    }

    ///
    /// Test func `save(likeId: Int)` returns successfully.
    ///
    /// Expect:
    ///    1. saveResult = success
    ///
    /// Condition:
    ///    1. Distributor_like
    ///              1-1. getResult = success
    ///              1-2. insertResult = success
    ///
    func testSaveLikeIdSuccess() {
        let mockDistributorCoreDataDao = MockDistributorCoreDataDao(getResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                    insertResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                    truncateResult: .failure(NSError(domain: "ignore", code: 0)))

        let mockDistributorLikeCoreDataDao = MockDistributorLikeCoreDataDao(getResult: .success([]),
                                                                            deleteResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            insertLikesResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            insertLikeIdResult: .success(()),
                                                                            truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        // sut
        makeSUT(distributorCoreDataDao: mockDistributorCoreDataDao, distributorLikeCoreDataDao: mockDistributorLikeCoreDataDao)

        let mockLikeId = Int64(1)

        let saveResult = sut.save(likeId: mockLikeId)

        switch saveResult {
        case .failure(let error):
            XCTFail(error.localizedDescription)

        default: break
        }
    }
    
    ///
    /// Test func `delete(likeId: Int)` returns successfully.
    ///
    /// Expect:
    ///    1. deleteResult = success
    ///
    /// Condition:
    ///    1. Distributor_like
    ///             1-1. deleteResult = success
    ///
    func testDeleteLikeIdSuccess() {
        let mockDistributorCoreDataDao = MockDistributorCoreDataDao(getResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                    insertResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                    truncateResult: .failure(NSError(domain: "ignore", code: 0)))

        let mockDistributorLikeCoreDataDao = MockDistributorLikeCoreDataDao(getResult: .success([]),
                                                                            deleteResult: .success(()),
                                                                            insertLikesResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            insertLikeIdResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        // sut
        makeSUT(distributorCoreDataDao: mockDistributorCoreDataDao, distributorLikeCoreDataDao: mockDistributorLikeCoreDataDao)

        let mockLikeId = Int64(1)

        let deleteResult = sut.delete(likeId: mockLikeId)

        switch deleteResult {
        case .failure(let error):
            XCTFail(error.localizedDescription)

        default: break
        }
    }
    
    ///
    /// Test func `get()` returns successfully.
    ///
    /// Expect:
    ///    1. count = `3`
    ///    2. Distributor(id: `1`, name: `PChome`, detail: `123456`, brandImage: `URL(string: "https://example.example1.jpg")!`, products: `Data()`, likeId: `1`)
    ///    3. Distributor(id: `2`, name: `蝦皮`, detail: `我在新加坡`, brandImage: `URL(string: "https://example.example2.jpg")!`, products: `Data()`, likeId: `nil`)
    ///    4. Distributor(id: `3`, name: `唉馬宋`, detail: `美國喔！`, brandImage: `URL(string: "https://example.example3.jpg")!`, products: `Data()`, likeId: `3`)
    ///
    /// Condition:
    ///    1. getResult = success([`mockDistributor_1`, `mockDistributor_2`, `mockDistributor_3`])
    ///
    func testGetSuccess() {
        let context = CoreDataController.shared.container.newBackgroundContext()

        // mock
        let mockDistributor_1 = get(id: 1,
                                  name: "PChome",
                                  detail: "123456",
                                  brandImage: URL(string: "https://example.example1.jpg")!,
                                  products: Data(),
                                  likeId: nil,
                                  context: context)
        let mockDistributor_2 = get(id: 2,
                                    name: "蝦皮",
                                    detail: "我在新加坡",
                                    brandImage: URL(string: "https://example.example2.jpg")!,
                                    products: Data(),
                                    likeId: nil,
                                    context: context)
        let mockDistributor_3 = get(id: 3,
                                    name: "唉馬宋",
                                    detail: "美國喔！",
                                    brandImage: URL(string: "https://example.example3.jpg")!,
                                    products: Data(),
                                    likeId: nil,
                                    context: context)
        
        let mockLike_1 = get(id: 1, context: context)
        let mockLike_2 = get(id: 3, context: context)
        
        let mockDistributorCoreDataDao = MockDistributorCoreDataDao(getResult: .success([mockDistributor_1, mockDistributor_2, mockDistributor_3]),
                                                                    insertResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                    truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        
        let mockDistributorLikeCoreDataDao = MockDistributorLikeCoreDataDao(getResult: .success([mockLike_1, mockLike_2]),
                                                                            deleteResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            insertLikesResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            insertLikeIdResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        
        // sut
        makeSUT(distributorCoreDataDao: mockDistributorCoreDataDao, distributorLikeCoreDataDao: mockDistributorLikeCoreDataDao)

        let result = sut.get()

        switch result {
        case .success(let distributors):
            
            XCTAssertEqual(distributors.count, 3)
            
            XCTAssertEqual(distributors[0].id, 1)
            XCTAssertEqual(distributors[0].name, "PChome")
            XCTAssertEqual(distributors[0].detail, "123456")
            XCTAssertEqual(distributors[0].brand_image, URL(string: "https://example.example1.jpg")!)
            XCTAssertEqual(distributors[0].products, Data())
            XCTAssertEqual(distributors[0].distributor_like?.id, 1)
            
            XCTAssertEqual(distributors[1].id, 2)
            XCTAssertEqual(distributors[1].name, "蝦皮")
            XCTAssertEqual(distributors[1].detail, "我在新加坡")
            XCTAssertEqual(distributors[1].brand_image, URL(string: "https://example.example2.jpg")!)
            XCTAssertEqual(distributors[1].products, Data())
            XCTAssertEqual(distributors[1].distributor_like?.id, nil)
            
            XCTAssertEqual(distributors[2].id, 3)
            XCTAssertEqual(distributors[2].name, "唉馬宋")
            XCTAssertEqual(distributors[2].detail, "美國喔！")
            XCTAssertEqual(distributors[2].brand_image, URL(string: "https://example.example3.jpg")!)
            XCTAssertEqual(distributors[2].products, Data())
            XCTAssertEqual(distributors[2].distributor_like?.id, 3)
            

        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    ///
    /// Test func `get(id: {id})` returns successfully.
    ///
    /// Expect:
    ///    1. count = `1`
    ///    2. Distributor(id: `1`, name: `PChome`, detail: `123456`, brandImage: `URL(string: "https://example.example1.jpg")!`, products: `Data()`, likeId: `1`)
    ///
    /// Condition:
    ///    1. getResult = success([`mockDistributor`])
    ///    2. id = `1`
    ///
    func testGetByIdSuccess() {
        let context = CoreDataController.shared.container.newBackgroundContext()

        // mock
        let mockDistributor = get(id: 1,
                                  name: "PChome",
                                  detail: "123456",
                                  brandImage: URL(string: "https://example.example1.jpg")!,
                                  products: Data(),
                                  likeId: 1,
                                  context: context)
        
        let mockLike = get(id: 1, context: context)
        
        let mockDistributorCoreDataDao = MockDistributorCoreDataDao(getResult: .success([mockDistributor]),
                                                                    insertResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                    truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        
        let mockDistributorLikeCoreDataDao = MockDistributorLikeCoreDataDao(getResult: .success([mockLike]),
                                                                            deleteResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            insertLikesResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            insertLikeIdResult: .failure(NSError(domain: "ignore", code: 0)),
                                                                            truncateResult: .failure(NSError(domain: "ignore", code: 0)))
        
        // sut
        makeSUT(distributorCoreDataDao: mockDistributorCoreDataDao, distributorLikeCoreDataDao: mockDistributorLikeCoreDataDao)

        let result = sut.getById(id: 1)

        switch result {
        case .success(let distributor):

            XCTAssertEqual(distributor.id, 1)
            XCTAssertEqual(distributor.name, "PChome")
            XCTAssertEqual(distributor.detail, "123456")
            XCTAssertEqual(distributor.brand_image, URL(string: "https://example.example1.jpg")!)
            XCTAssertEqual(distributor.products, Data())
            XCTAssertEqual(distributor.distributor_like?.id, 1)

        case .failure(let error):
            XCTFail(error.localizedDescription)
        }
    }
    
    private func get(id: Int64, name: String, detail: String, brandImage: URL, products: Data, likeId: Int64?, context: NSManagedObjectContext) -> Distributor {
        let distributor = Distributor(context: context)
        distributor.id = id
        distributor.name = name
        distributor.detail = detail
        distributor.brand_image = brandImage
        distributor.products = products
        
        if let likeId = likeId {
            distributor.distributor_like?.id = likeId
        }
        
        return distributor
    }
    
    private func get(id: Int64, context: NSManagedObjectContext) -> Distributor_Like {
        let distributor = Distributor_Like(context: context)
        distributor.id = id
        
        return distributor
    }
    
    private func makeSUT(distributorCoreDataDao: DistributorCoreDataDaoType, distributorLikeCoreDataDao: DistributorLikeCoreDataDaoType) {
        sut = DistributorCoreDataService(distributorCoreDataDao: distributorCoreDataDao,
                                         distributorLikeCoreDataDao: distributorLikeCoreDataDao)
    }
}

private class MockDistributorCoreDataDao: DistributorCoreDataDaoType {
    private let getResult: Result<[Persistence.Distributor], Error>
    private let insertResult: Result<Void, Error>
    private let truncateResult: Result<Void, Error>
    
    init(getResult: Result<[Persistence.Distributor], Error>, insertResult: Result<Void, Error>, truncateResult: Result<Void, Error>) {
        self.getResult = getResult
        self.insertResult = insertResult
        self.truncateResult = truncateResult
    }
    
    func get(id: Int64?) throws -> [Persistence.Distributor] {
        switch getResult {
        case .success(let distributor):
            return distributor
        case .failure(let error):
            throw error
        }
    }
    
    func insert(distributors: [Persistence.Distributor]) throws {
        switch insertResult {
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

private class MockDistributorLikeCoreDataDao: DistributorLikeCoreDataDaoType {
    private let getResult: Result<[Persistence.Distributor_Like], Error>
    private let deleteResult: Result<Void, Error>
    private let insertLikesResult: Result<Void, Error>
    private let insertLikeIdResult: Result<Void, Error>
    private let truncateResult: Result<Void, Error>
    
    init(getResult: Result<[Persistence.Distributor_Like], Error>, deleteResult: Result<Void, Error>, insertLikesResult: Result<Void, Error>, insertLikeIdResult: Result<Void, Error>, truncateResult: Result<Void, Error>) {
        self.getResult = getResult
        self.deleteResult = deleteResult
        self.insertLikesResult = insertLikesResult
        self.insertLikeIdResult = insertLikeIdResult
        self.truncateResult = truncateResult
    }
    
    func get(id: Int64?) throws -> [Persistence.Distributor_Like] {
        switch getResult {
        case .success(let like):
            return like
        case .failure(let error):
            throw error
        }
    }
    
    func insert(likes: [Persistence.Distributor_Like]) throws {
        switch insertLikesResult {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
    
    func insert(id: Int64) throws {
        switch insertLikeIdResult {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
    
    func delete(id: Int64) throws {
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
