//
//  TestProductCoreDataServiceTests.swift
//  SCSH_3C_iOSTests
//
//  Created by 辜敬閎 on 2023/8/7.
//

import XCTest
import Combine
@testable import Persistence

final class ProductCoreDataServiceTests: XCTestCase {

    var sut: ProductCoreDataService!
    var cancellables = Set<AnyCancellable>()
    
    ///
    /// Test `Select * from Product` in CoreData returns successfully.
    ///
    /// Expect:
    ///    1. Product(name: `"A123"`), Product(name: `"A222"`), Product(name: `"a557"`)
    ///
    /// Condition:
    ///    1. data `name:"A123"` & `name: "A222"` & `name: "B333"` & `name: "a557"` already existed in the table Product.
    ///    2. query: `name like[c] *"A"*`
    ///
    func testGetByName() {
        sut = makeSUT()
        
        let mockQueryName = "A"
        let mockNames = ["A123", "A222", "B333", "a557"]
        
        sut.save(names: mockNames) 
            .flatMap { _ -> AnyPublisher<[Product], Error> in
                self.sut.get(name: mockQueryName)
            }
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break;
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }, receiveValue: { products in
                XCTAssertEqual(products.count, 3)
                XCTAssertEqual(products[0].name, "A123")
                XCTAssertEqual(products[1].name, "A222")
                XCTAssertEqual(products[2].name, "a557")
                
            })
            .store(in: &cancellables)
    }
    
    private func makeSUT() -> ProductCoreDataService {
        ProductCoreDataService()
    }
}
