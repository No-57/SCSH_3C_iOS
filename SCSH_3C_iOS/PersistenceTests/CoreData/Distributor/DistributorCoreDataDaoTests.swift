//
//  DistributorCoreDataDaoTests.swift
//  PersistenceTests
//
//  Created by 辜敬閎 on 2023/12/5.
//

import XCTest
import CoreData
@testable import Persistence

final class DistributorCoreDataDaoTests: XCTestCase {

    var sut: DistributorCoreDataDao!

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    ///
    /// Test `teuncate Table Distributor` in CoreData returns successfully.
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
    /// Test `insert into Distributor (a, b, c) values (1, 2, 3)` returns successfully.
    ///
    /// Expect:
    ///    1. count = `3`
    ///    2. `mockDistributor_1`,
    ///    3. `mockDistributor_2`,
    ///    4. `mockDistributor_3`,
    ///
    /// Condition:
    ///       Table `Distributor` is empty
    ///
    ///
    func testInsertSuccess() throws {
        // sut
        makeSUT()

        let context = CoreDataController.shared.container.newBackgroundContext()

        let mockDistributor_1 = get(id: 1,
                                    name: "PChome",
                                    detail: "123456",
                                    brandImage: URL(string: "https://example.example1.jpg")!,
                                    products:
                                        getProductData(mockProducts: [
                                            MockProduct(id: 1, imageURL: URL(string: "https://example.example1.jpg")!),
                                            MockProduct(id: 2, imageURL: URL(string: "https://example.example5.jpg")!),
                                            MockProduct(id: 3, imageURL: URL(string: "https://example.example6.jpg")!)
                                        ]),
                                    likeId: nil,
                                    context: context)
        let mockDistributor_2 = get(id: 2,
                                    name: "蝦皮",
                                    detail: "我在新加坡",
                                    brandImage: URL(string: "https://example.example2.jpg")!,
                                    products:
                                        getProductData(mockProducts: [
                                            MockProduct(id: 7, imageURL: URL(string: "https://example.example7.jpg")!),
                                            MockProduct(id: 6, imageURL: URL(string: "https://example.example6.jpg")!),
                                            MockProduct(id: 4, imageURL: URL(string: "https://example.example4.jpg")!)
                                        ]),
                                    likeId: nil,
                                    context: context)
        let mockDistributor_3 = get(id: 3,
                                    name: "唉馬宋",
                                    detail: "美國喔！",
                                    brandImage: URL(string: "https://example.example3.jpg")!,
                                    products:
                                        getProductData(mockProducts: [
                                            MockProduct(id: 8, imageURL: URL(string: "https://example.example8.jpg")!),
                                            MockProduct(id: 9, imageURL: URL(string: "https://example.example9.jpg")!),
                                            MockProduct(id: 88, imageURL: URL(string: "https://example.example8.jpg")!)
                                        ]),
                                    likeId: nil,
                                    context: context)

        do {
            try sut.truncate()
            try sut.insert(distributors: [mockDistributor_1, mockDistributor_2, mockDistributor_3])

            let result = try sut.get(id: nil)

            XCTAssertEqual(result.count, 3)

            XCTAssertEqual(result[0].id, 1)
            XCTAssertEqual(result[0].name, "PChome")
            XCTAssertEqual(result[0].detail, "123456")
            XCTAssertEqual(result[0].brand_image, URL(string: "https://example.example1.jpg")!)
            
            XCTAssertEqual(result[0].products, getProductData(mockProducts: [
                MockProduct(id: 1, imageURL: URL(string: "https://example.example1.jpg")!),
                MockProduct(id: 2, imageURL: URL(string: "https://example.example5.jpg")!),
                MockProduct(id: 3, imageURL: URL(string: "https://example.example6.jpg")!)
            ]))
            XCTAssertEqual(result[0].distributor_like?.id, nil)
            
            XCTAssertEqual(result[1].id, 2)
            XCTAssertEqual(result[1].name, "蝦皮")
            XCTAssertEqual(result[1].detail, "我在新加坡")
            XCTAssertEqual(result[1].brand_image, URL(string: "https://example.example2.jpg")!)
            XCTAssertEqual(result[1].products, getProductData(mockProducts: [
                MockProduct(id: 7, imageURL: URL(string: "https://example.example7.jpg")!),
                MockProduct(id: 6, imageURL: URL(string: "https://example.example6.jpg")!),
                MockProduct(id: 4, imageURL: URL(string: "https://example.example4.jpg")!)
            ]))
            XCTAssertEqual(result[1].distributor_like?.id, nil)
            
            XCTAssertEqual(result[2].id, 3)
            XCTAssertEqual(result[2].name, "唉馬宋")
            XCTAssertEqual(result[2].detail, "美國喔！")
            XCTAssertEqual(result[2].brand_image, URL(string: "https://example.example3.jpg")!)
            XCTAssertEqual(result[2].products, getProductData(mockProducts: [
                MockProduct(id: 8, imageURL: URL(string: "https://example.example8.jpg")!),
                MockProduct(id: 9, imageURL: URL(string: "https://example.example9.jpg")!),
                MockProduct(id: 88, imageURL: URL(string: "https://example.example8.jpg")!)
            ]))
            XCTAssertEqual(result[2].distributor_like?.id, nil)

        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    ///
    /// Test `select * from Distributor where id == {id}` returns successfully.
    ///
    /// Expect:
    ///    1. count = `3`
    ///    2. `mockDistributor_1`,
    ///    3. `mockDistributor_2`,
    ///    4. `mockDistributor_3`,
    ///
    /// Condition:
    ///       Table `Distributor` is empty
    ///
    ///
    func testGetByIdSuccess() throws {
        // sut
        makeSUT()

        let context = CoreDataController.shared.container.newBackgroundContext()

        let mockDistributor_1 = get(id: 1,
                                    name: "PChome",
                                    detail: "123456",
                                    brandImage: URL(string: "https://example.example1.jpg")!,
                                    products:
                                        getProductData(mockProducts: [
                                            MockProduct(id: 1, imageURL: URL(string: "https://example.example1.jpg")!),
                                            MockProduct(id: 2, imageURL: URL(string: "https://example.example5.jpg")!),
                                            MockProduct(id: 3, imageURL: URL(string: "https://example.example6.jpg")!)
                                        ]),
                                    likeId: nil,
                                    context: context)
        let mockDistributor_2 = get(id: 2,
                                    name: "蝦皮",
                                    detail: "我在新加坡",
                                    brandImage: URL(string: "https://example.example2.jpg")!,
                                    products:
                                        getProductData(mockProducts: [
                                            MockProduct(id: 7, imageURL: URL(string: "https://example.example7.jpg")!),
                                            MockProduct(id: 6, imageURL: URL(string: "https://example.example6.jpg")!),
                                            MockProduct(id: 4, imageURL: URL(string: "https://example.example4.jpg")!)
                                        ]),
                                    likeId: nil,
                                    context: context)
        let mockDistributor_3 = get(id: 3,
                                    name: "唉馬宋",
                                    detail: "美國喔！",
                                    brandImage: URL(string: "https://example.example3.jpg")!,
                                    products:
                                        getProductData(mockProducts: [
                                            MockProduct(id: 8, imageURL: URL(string: "https://example.example8.jpg")!),
                                            MockProduct(id: 9, imageURL: URL(string: "https://example.example9.jpg")!),
                                            MockProduct(id: 88, imageURL: URL(string: "https://example.example8.jpg")!)
                                        ]),
                                    likeId: nil,
                                    context: context)

        do {
            try sut.truncate()
            try sut.insert(distributors: [mockDistributor_1, mockDistributor_2, mockDistributor_3])

            let result = try sut.get(id: 2)

            XCTAssertEqual(result.count, 1)

            XCTAssertEqual(result[0].id, 2)
            XCTAssertEqual(result[0].name, "蝦皮")
            XCTAssertEqual(result[0].detail, "我在新加坡")
            XCTAssertEqual(result[0].brand_image, URL(string: "https://example.example2.jpg")!)
            XCTAssertEqual(result[0].products, getProductData(mockProducts: [
                MockProduct(id: 7, imageURL: URL(string: "https://example.example7.jpg")!),
                MockProduct(id: 6, imageURL: URL(string: "https://example.example6.jpg")!),
                MockProduct(id: 4, imageURL: URL(string: "https://example.example4.jpg")!)
            ]))
            XCTAssertEqual(result[0].distributor_like?.id, nil)
            
        } catch {
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
    
    private func getProductData(mockProducts: [MockProduct]) -> Data {
        try! encoder.encode(mockProducts)
    }
    
    private func makeSUT() {
        sut = DistributorCoreDataDao()
    }
}

private struct MockProduct: Codable {
    private let id: Int
    private let imageURL: URL
    
    init(id: Int, imageURL: URL) {
        self.id = id
        self.imageURL = imageURL
    }
}
