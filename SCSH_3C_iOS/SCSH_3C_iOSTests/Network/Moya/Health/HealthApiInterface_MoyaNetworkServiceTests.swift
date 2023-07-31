//
//  HealthApiInterface_MoyaNetworkServiceTests.swift
//  SCSH_3C_iOSTests
//
//  Created by 辜敬閎 on 2023/7/26.
//

import XCTest
import Moya
@testable import SCSH_3C_iOS

final class HealthApiInterface_MoyaNetworkServiceTests: XCTestCase {
    
    var sut: MoyaNetworkService<HealthApiInterface>!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    ///
    /// Test API: `/health` returns successfully.
    ///
    /// Expect:
    ///     1. `success` is executed
    ///     2. returns `HealthApiModel(message: "Service is Healthy !")`
    ///
    /// Condition:
    ///     1. Status: `201`
    ///     2. data: `{message: "Service is healthy !"}`
    ///
    func testHealthApiFetchesSuccessWithCode201AndCorrectData() {
        // sut
        let mockData = makeMockData(jsonData: ["message": "Service is healthy !"])
        makeSUT(statusCode: 201, data: mockData)
         
        let successIsExecuted = expectation(description: "success")
        
        sut.fetch(success: { outputModel in
            successIsExecuted.fulfill()
            XCTAssertEqual(outputModel, HealthApiModel(message: "Service is healthy !"))
        }, failure: { (error) in
            XCTFail()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [successIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/health` returns successfully.
    ///
    /// Expect:
    ///     1. `success` is executed
    ///     2. returns `HealthApiModel(message: "Service is Healthy !")`
    ///
    /// Condition:
    ///     1. Status: `201`
    ///     2. data: `{message2: "Service is healthy !"}`
    ///
    func testHealthApiFetchesFailureWithCode201AndWrongData() {
        // sut
        let mockData = makeMockData(jsonData: ["message2": "Service is healthy !"])
        makeSUT(statusCode: 201, data: mockData)
         
        let failureIsExecuted = expectation(description: "failure")
        
        sut.fetch(success: { outputModel in
            XCTFail()
        }, failure: { (error) in
            failureIsExecuted.fulfill()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [failureIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/health` returns successfully.
    ///
    /// Expect:
    ///     1. `success` is executed
    ///     2. returns `HealthApiModel(message: "Service is Healthy !")`
    ///
    /// Condition:
    ///     1. Status: `301`
    ///     2. data: `{message: "Service is healthy !"}`
    ///
    func testHealthApiFetchesSuccessWithCode301AndCorrectData() {
        // sut
        let mockData = makeMockData(jsonData: ["message": "Service is healthy !"])
        makeSUT(statusCode: 301, data: mockData)
         
        let successIsExecuted = expectation(description: "success")
        
        sut.fetch(success: { outputModel in
            successIsExecuted.fulfill()
            XCTAssertEqual(outputModel, HealthApiModel(message: "Service is healthy !"))
        }, failure: { (error) in
            XCTFail()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [successIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/health` returns failure.
    ///
    /// Expect:
    ///     1. `failure` is executed
    ///
    /// Condition:
    ///     1. Status: `500`
    ///     2. data: `{message: "Service is healthy !"}`
    ///
    func testHealthApiFetchesFailureWithCode500AndCorrectData() {
        // sut
        let mockData = makeMockData(jsonData: ["message": "Service is healthy !"])
        makeSUT(statusCode: 500, data: mockData)

        let failureIsExecuted = expectation(description: "failure")

        sut.fetch(success: { _ in
            XCTFail()
        }, failure: { (error) in
            failureIsExecuted.fulfill()
        })

        XCTAssertEqual(XCTWaiter.wait(for: [failureIsExecuted], timeout: 1), .completed)
    }
    
    private func makeSUT(healthApiInterface: HealthApiInterface = HealthApiInterface(), statusCode: Int, data: Data) {
        
        // For testing, we will use a MoyaProvider with stubbed data
        let stubbingProvider = MoyaProvider<HealthApiInterface>(endpointClosure: { target -> Endpoint in
            
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(statusCode, data) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }, stubClosure: MoyaProvider.immediatelyStub)
        
        sut = MoyaNetworkService(moyaProvider: stubbingProvider, moyaApiInterface: healthApiInterface)
    }
    
    private func makeMockData(jsonData: [String: String]) -> Data {
        try! JSONSerialization.data(withJSONObject: jsonData)
    }
}
