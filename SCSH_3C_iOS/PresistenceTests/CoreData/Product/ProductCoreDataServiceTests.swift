//
//  TestProductCoreDataServiceTests.swift
//  SCSH_3C_iOSTests
//
//  Created by 辜敬閎 on 2023/8/7.
//

import XCTest
@testable import Presistence

final class ProductCoreDataServiceTests: XCTestCase {

    var sut: ProductCoreDataService!
    
    ///
    /// Test `Select * from Product` in CoreData returns successfully.
    ///
    /// Expect:
    ///    1. Product(name: `"A123"`), Product(name: `"A222"`)
    ///
    /// Condition:
    ///    1. data `name:"A123"` & `name: "A222"` already existed in the table Product.
    ///
    func testGet() {
        sut = makeSUT()
        
        let mockNames = ["A123", "A222"]
        let saveResult = sut.save(names: mockNames)
        let queryResult = sut.get()
        
        switch (saveResult, queryResult) {
            
        case (.success, .success(let products)):

            XCTAssertFalse(products.isEmpty) // check result is not empty
            for (index, product) in products.enumerated() {
                XCTAssertEqual(product.name, mockNames[index])
            }

        default:
            XCTFail()
        }
    }
    
    private func makeSUT() -> ProductCoreDataService {
        ProductCoreDataService()
    }
}
