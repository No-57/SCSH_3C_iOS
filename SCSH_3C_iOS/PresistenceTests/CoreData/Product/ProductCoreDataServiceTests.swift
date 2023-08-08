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
    
    func testGet() {
        sut = makeSUT()

    }
    
    private func makeSUT() -> ProductCoreDataService {
        ProductCoreDataService()
    }

}
