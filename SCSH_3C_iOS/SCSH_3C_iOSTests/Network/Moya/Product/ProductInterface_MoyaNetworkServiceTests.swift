//
//  ProductInterface_MoyaNetworkServiceTests.swift
//  SCSH_3C_iOSTests
//
//  Created by 辜敬閎 on 2023/7/31.
//

import XCTest
import Moya
@testable import SCSH_3C_iOS

final class ProductInterface_MoyaNetworkServiceTests: XCTestCase {

    var sut: MoyaNetworkService<ProductApiInterface>!
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    ///
    /// Test API: `/product` returns successfully.
    ///
    /// Expect:
    ///     1. `success` is executed
    ///     2. returns `ProductApiModel(names: ["iphone 14", "iphone 15"])`
    ///
    /// Condition:
    ///     1. parameters: `nil`
    ///     2. Status: `201`
    ///     3. data: `{names: ["iphone 14", "iphone 15"]}`
    ///
    func testProductApiFetchesSuccessWithEmptyParametersAndCode201AndCorrectData() {
        // sut
        let productApiInterface = ProductApiInterface(name: nil)
        let mockData = makeMockData(jsonData: ["names": ["iphone 14", "iphone 15"]])
        makeSUT(productApiInterface: productApiInterface, statusCode: 201, data: mockData)
         
        let successIsExecuted = expectation(description: "success")
        
        sut.fetch(success: { outputModel in
            successIsExecuted.fulfill()
            XCTAssertEqual(outputModel, ProductApiModel(names: ["iphone 14", "iphone 15"]))
        }, failure: { (error) in
            XCTFail()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [successIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/product` returns successfully.
    ///
    /// Expect:
    ///     1. `success` is executed
    ///     2. returns `ProductApiModel(names: ["iphone 14", "iphone 15"])`
    ///
    /// Condition:
    ///     1. parameters: `name=123`
    ///     2. Status: `201`
    ///     3. data: `{names: ["iphone 14", "iphone 15"]}`
    ///
    func testProductApiFetchesSuccessWithCorrectParametersAndCode201AndCorrectData() {
        // sut
        let productApiInterface = ProductApiInterface(name: "123")
        let mockData = makeMockData(jsonData: ["names": ["iphone 14", "iphone 15"]])
        makeSUT(productApiInterface: productApiInterface, statusCode: 201, data: mockData)
         
        let successIsExecuted = expectation(description: "success")
        
        sut.fetch(success: { outputModel in
            successIsExecuted.fulfill()
            XCTAssertEqual(outputModel, ProductApiModel(names: ["iphone 14", "iphone 15"]))
        }, failure: { (error) in
            XCTFail()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [successIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/product` returns successfully.
    ///
    /// Expect:
    ///     1. `failure` is executed
    ///     2. returns `ProductApiModel(names: ["iphone 14", "iphone 15"])`
    ///
    /// Condition:
    ///     1. parameters: `name=123`
    ///     2. Status: `201`
    ///     3. data: `{names2: ["iphone 14", "iphone 15"]}`
    ///
    func testProductApiFetchesFailureWithCorrectParametersAndCode201AndWrongData() {
        // sut
        let productApiInterface = ProductApiInterface(name: "123")
        let mockData = makeMockData(jsonData: ["names2": ["iphone 14", "iphone 15"]])
        makeSUT(productApiInterface: productApiInterface, statusCode: 201, data: mockData)
         
        let failureIsExecuted = expectation(description: "failure")
        
        sut.fetch(success: { outputModel in
            XCTFail()
        }, failure: { (error) in
            failureIsExecuted.fulfill()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [failureIsExecuted], timeout: 1), .completed)
    }

    ///
    /// Test API: `/product` returns successfully.
    ///
    /// Expect:
    ///     1. `success` is executed
    ///     2. returns `ProductApiModel(names: ["iphone 14", "iphone 15"])`
    ///
    /// Condition:
    ///     1. parameters: `name=123`
    ///     2. Status: `301`
    ///     3. data: `{names: ["iphone 14", "iphone 15"]}`
    ///
    func testProductApiFetchesSuccessWithCorrectParametersAndCode301AndCorrectData() {
        // sut
        let productApiInterface = ProductApiInterface(name: "123")
        let mockData = makeMockData(jsonData: ["names": ["iphone 14", "iphone 15"]])
        makeSUT(productApiInterface: productApiInterface, statusCode: 301, data: mockData)
         
        let successIsExecuted = expectation(description: "success")
        
        sut.fetch(success: { outputModel in
            successIsExecuted.fulfill()
            XCTAssertEqual(outputModel, ProductApiModel(names: ["iphone 14", "iphone 15"]))
        }, failure: { (error) in
            XCTFail()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [successIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/product` returns successfully.
    ///
    /// Expect:
    ///     1. `failure` is executed
    ///
    /// Condition:
    ///     1. parameters: `name=123`
    ///     2. Status: `301`
    ///     3. data: `{names: ["iphone 14", "iphone 15"]}`
    ///
    func testProductApiFetchesFailureWithCorrectParametersAndCode500AndCorrectData() {
        // sut
        let productApiInterface = ProductApiInterface(name: "123")
        let mockData = makeMockData(jsonData: ["names": ["iphone 14", "iphone 15"]])
        makeSUT(productApiInterface: productApiInterface, statusCode: 500, data: mockData)
         
        let failureIsExecuted = expectation(description: "failure")
        
        sut.fetch(success: { outputModel in
            XCTFail()
        }, failure: { error in
            failureIsExecuted.fulfill()
        })

        XCTAssertEqual(XCTWaiter.wait(for: [failureIsExecuted], timeout: 1), .completed)
    }
    
    private func makeSUT(productApiInterface: ProductApiInterface, statusCode: Int, data: Data) {
        
        // For testing, we will use a MoyaProvider with stubbed data
        let stubbingProvider = MoyaProvider<ProductApiInterface>(endpointClosure: { target -> Endpoint in
            
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(statusCode, data) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }, stubClosure: MoyaProvider.immediatelyStub)
        
        sut = MoyaNetworkService(moyaProvider: stubbingProvider, moyaApiInterface: productApiInterface)
    }
    
    private func makeMockData(jsonData: [String: [String]]) -> Data {
        try! JSONSerialization.data(withJSONObject: jsonData)
    }
}
