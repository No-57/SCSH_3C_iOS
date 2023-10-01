//
//  HealthApiInterface_MoyaNetworkServiceTests.swift
//  SCSH_3C_iOSTests
//
//  Created by 辜敬閎 on 2023/7/26.
//

import XCTest
import Moya
@testable import Networking

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
    ///     2. code = `123`
    ///     3. data = `HealthApiModel(health: "kkk", time: "dateeee")`
    ///
    /// Condition:
    ///     1. statusCode: 201
    ///     2. data: {
    ///             code: 123,
    ///             data: {
    ///                 "health": "kkk",
    ///                 "time": "dateeee"
    ///             }
    ///     }
    ///
    func testHealthApiFetchesSuccessWithCode2XXAndCorrectData() {
        // sut
        let mockData = makeMockData(jsonData: ["code": 123, "data": ["health": "kkk", "time": "dateeee"]])
        makeSUT(statusCode: 201, data: mockData)
         
        let successIsExecuted = expectation(description: "success")
        
        sut.fetch(success: { outputModel in
            successIsExecuted.fulfill()
            XCTAssertEqual(outputModel.code, 123)
            XCTAssertEqual(outputModel.data, HealthApiModel(health: "kkk", time: "dateeee"))
        }, failure: { (error) in
            print(error)
            XCTFail()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [successIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/health` returns successfully.
    ///
    /// Expect:
    ///     1. `failure` is executed
    ///
    /// Condition:
    ///     1. statusCode: 201
    ///     2. data: {
    ///         message2: "Service is healthy !"
    ///     }
    ///
    func testHealthApiFetchesFailureWithCode2XXAndWrongData() {
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
    ///     2. code = `123`
    ///     3. data = `HealthApiModel(health: "kkk", time: "dateeee")`
    ///
    /// Condition:
    ///     1. statusCode: 301
    ///     2. data: {
    ///             code: 123,
    ///             data: {
    ///                     "health": "kkk",
    ///                     "time": "dateeee"
    ///             }
    ///     }
    ///
    func testHealthApiFetchesSuccessWithCode3XXAndCorrectData() {
        // sut
        let mockData = makeMockData(jsonData: ["code": 123, "data": ["health": "kkk", "time": "dateeee"]])
        makeSUT(statusCode: 301, data: mockData)
         
        let successIsExecuted = expectation(description: "success")
        
        sut.fetch(success: { outputModel in
            successIsExecuted.fulfill()
            XCTAssertEqual(outputModel.code, 123)
            XCTAssertEqual(outputModel.data, HealthApiModel(health: "kkk", time: "dateeee"))
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
    ///     2. data = `ApiError(code: 123, extra: "aaa", message: "whatever")`
    ///
    /// Condition:
    ///     1. statusCode: 422
    ///     2. data: {
    ///             code: 123,
    ///             extra: "aaa",
    ///             message: "whatever"
    ///     }
    ///
    func testHealthApiFetchesFailureWithCode4XXAndCorrectData() {
        // sut
        let mockData = makeMockData(jsonData: ["code": 123, "extra": "aaa", "message": "whatever"])
        makeSUT(statusCode: 422, data: mockData)

        let failureIsExecuted = expectation(description: "failure")

        sut.fetch(success: { _ in
            XCTFail()
        }, failure: { (error) in
            failureIsExecuted.fulfill()
            let apiError = error as? ApiError
            XCTAssertNotNil(apiError)
            XCTAssertEqual(apiError!, ApiError(code: 123, extra: "aaa", message: "whatever"))
        })

        XCTAssertEqual(XCTWaiter.wait(for: [failureIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/health` returns failure.
    ///
    /// Expect:
    ///     1. `failure` is executed
    ///     2. data = `ApiError(code: 123, extra: nil, message: "whatever")`
    ///
    /// Condition:
    ///     1. statusCode: 500
    ///     2. data: {
    ///             code: 123,
    ///             extra: nil,
    ///             message: "whatever"
    ///     }
    ///
    func testHealthApiFetchesFailureWithCode5XXAndCorrectData() {
        // sut
        let mockData = makeMockData(jsonData: ["code": 123, "extra": nil, "message": "whatever"])
        makeSUT(statusCode: 500, data: mockData)

        let failureIsExecuted = expectation(description: "failure")

        sut.fetch(success: { _ in
            XCTFail()
        }, failure: { (error) in
            failureIsExecuted.fulfill()
            let apiError = error as? ApiError
            XCTAssertNotNil(apiError)
            XCTAssertEqual(apiError!, ApiError(code: 123, extra: nil, message: "whatever"))
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
    
    private func makeMockData(jsonData: [String: Any]) -> Data {
        try! JSONSerialization.data(withJSONObject: jsonData)
    }
}
