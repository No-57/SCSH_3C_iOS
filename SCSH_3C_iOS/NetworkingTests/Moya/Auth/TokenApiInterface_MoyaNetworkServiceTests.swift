//
//  TokenApiInterface_MoyaNetworkServiceTests.swift
//  NetworkingTests
//
//  Created by 辜敬閎 on 2023/10/2.
//

import XCTest
import Moya
@testable import Networking

final class TokenApiInterface_MoyaNetworkServiceTests: XCTestCase {
    
    var sut: MoyaNetworkService<TokenApiInterface>!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    ///
    /// Test API: `/token` returns successfully.
    ///
    /// Expect:
    ///     1. `success` is executed
    ///     2. code = `0000`
    ///     3. data = `TokenApiModel(accessToken: "eyJhbOiJIUzI1NiI", refreshToken: "7eHeBIU$$jD2gKPX-Es9nA")`
    ///
    /// Condition:
    ///     1. refreshToken: AAAAA
    ///     2. statusCode: 201
    ///     3. data: {
    ///             code: 0000,
    ///             data: {
    ///                     "access_token": "eyJhbOiJIUzI1NiI",
    ///                     "refresh_token": "7eHeBIU$$jD2gKPX-Es9nA"
    ///             }
    ///     }
    ///
    func testTokenApiFetchesSuccessWithCode2XXAndCorrectData() {
        // sut
        let tokenApiInterface = TokenApiInterface(refreshToken: "AAAAA")
        let mockData = makeMockData(jsonData: ["code": 0000, "data": ["access_token": "eyJhbOiJIUzI1NiI", "refresh_token": "7eHeBIU$$jD2gKPX-Es9nA"]])
        makeSUT(tokenApiInterface: tokenApiInterface, statusCode: 201, data: mockData)
         
        let successIsExecuted = expectation(description: "success")
        
        sut.fetch(success: { outputModel in
            successIsExecuted.fulfill()
            XCTAssertEqual(outputModel.code, 0000)
            XCTAssertEqual(outputModel.data, TokenApiModel(accessToken: "eyJhbOiJIUzI1NiI", refreshToken: "7eHeBIU$$jD2gKPX-Es9nA"))
        }, failure: { (error) in
            XCTFail()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [successIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/token` returns failure.
    ///
    /// Expect:
    ///     1. `failure` is executed
    ///
    /// Condition:
    ///     1. refreshToken: AAAAA
    ///     2. statusCode: 201
    ///     3. data: {
    ///             code: 0000,
    ///             data: {
    ///                     "access_token2": "eyJhbOiJIUzI1NiI",
    ///                     "refresh_token": "7eHeBIU$$jD2gKPX-Es9nA"
    ///             }
    ///     }
    ///
    func testTokenApiFetchesFailureWithCode2XXAndWrongData() {
        // sut
        let tokenApiInterface = TokenApiInterface(refreshToken: "AAAAA")
        let mockData = makeMockData(jsonData: ["code": 0000, "data": ["access_token2": "eyJhbGciOiJIUzI1NiI", "refresh_token": "7eHeBIUjD2gKPX-Es9nA"]])
        makeSUT(tokenApiInterface: tokenApiInterface, statusCode: 201, data: mockData)
         
        let failureIsExecuted = expectation(description: "failure")
        
        sut.fetch(success: { outputModel in
            XCTFail()
        }, failure: { (error) in
            failureIsExecuted.fulfill()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [failureIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/token` returns successfully.
    ///
    /// Expect:
    ///     1. `success` is executed
    ///     2. code = `0000`
    ///     3. data = `TokenApiModel(accessToken: "eyJhbOiJIUzI1NiI", refreshToken: "7eHeBIU$$jD2gKPX-Es9nA")`
    ///
    /// Condition:
    ///     1. refreshToken: AAAAA
    ///     2. statusCode: 333
    ///     3. data: {
    ///             code: 0000,
    ///             data: {
    ///                     "access_token": "eyJhbOiJIUzI1NiI",
    ///                     "refresh_token": "7eHeBIU$$jD2gKPX-Es9nA"
    ///             }
    ///     }
    ///
    func testTokenApiFetchesSuccessWithCode3XXAndCorrectData() {
        // sut
        let tokenApiInterface = TokenApiInterface(refreshToken: "AAAAA")
        let mockData = makeMockData(jsonData: ["code": 0000, "data": ["access_token": "eyJhbOiJIUzI1NiI", "refresh_token": "7eHeBIU$$jD2gKPX-Es9nA"]])
        makeSUT(tokenApiInterface: tokenApiInterface, statusCode: 333, data: mockData)
         
        let successIsExecuted = expectation(description: "success")
        
        sut.fetch(success: { outputModel in
            successIsExecuted.fulfill()
            XCTAssertEqual(outputModel.code, 0000)
            XCTAssertEqual(outputModel.data, TokenApiModel(accessToken: "eyJhbOiJIUzI1NiI", refreshToken: "7eHeBIU$$jD2gKPX-Es9nA"))
        }, failure: { (error) in
            XCTFail()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [successIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/token` returns failure.
    ///
    /// Expect:
    ///     1. `failure` is executed
    ///     2. data = `ApiError(code: 12355, extra: "aaa", message: "?????")`
    ///
    /// Condition:
    ///     1. refreshToken: AAAAA
    ///     2. statusCode: 422
    ///     3. data: {
    ///             code: 123,
    ///             extra: "aaa",
    ///             message: "?????"
    ///     }
    ///
    func testTokenApiFetchesFailureWithCode4XXAndCorrectData() {
        // sut
        let tokenApiInterface = TokenApiInterface(refreshToken: "AAAAA")
        let mockData = makeMockData(jsonData: ["code": 123, "extra": "aaa", "message": "?????"])
        makeSUT(tokenApiInterface: tokenApiInterface, statusCode: 422, data: mockData)

        let failureIsExecuted = expectation(description: "failure")

        sut.fetch(success: { outputModel in
            XCTFail()
        }, failure: { (error) in
            failureIsExecuted.fulfill()
            let apiError = error as? ApiError
            XCTAssertNotNil(apiError)
            XCTAssertEqual(apiError!, ApiError(code: 123, extra: "aaa", message: "?????"))
        })

        XCTAssertEqual(XCTWaiter.wait(for: [failureIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/token` returns failure.
    ///
    /// Expect:
    ///     1. `failure` is executed
    ///     2. data = `ApiError(code: 12355, extra: nil, message: "?????")`
    ///
    /// Condition:
    ///     1. refreshToken: AAAAA
    ///     2. statusCode: 588
    ///     3. data: {
    ///             code: 12355,
    ///             extra: nil,
    ///             message: "?????"
    ///     }
    ///
    func testTokenApiFetchesFailureWithCode5XXAndCorrectData() {
        // sut
        let tokenApiInterface = TokenApiInterface(refreshToken: "AAAAA")
        let mockData = makeMockData(jsonData: ["code": 12355, "extra": nil, "message": "?????"])
        makeSUT(tokenApiInterface: tokenApiInterface, statusCode: 588, data: mockData)

        let failureIsExecuted = expectation(description: "failure")

        sut.fetch(success: { outputModel in
            XCTFail()
        }, failure: { (error) in
            failureIsExecuted.fulfill()
            let apiError = error as? ApiError
            XCTAssertNotNil(apiError)
            XCTAssertEqual(apiError!, ApiError(code: 12355, extra: nil, message: "?????"))
        })

        XCTAssertEqual(XCTWaiter.wait(for: [failureIsExecuted], timeout: 1), .completed)
    }
    
    private func makeSUT(tokenApiInterface: TokenApiInterface, statusCode: Int, data: Data) {
        
        // For testing, we will use a MoyaProvider with stubbed data
        let stubbingProvider = MoyaProvider<TokenApiInterface>(endpointClosure: { target -> Endpoint in
            
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(statusCode, data) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }, stubClosure: MoyaProvider.immediatelyStub)
        
        sut = MoyaNetworkService(moyaProvider: stubbingProvider, moyaApiInterface: tokenApiInterface)
    }
    
    private func makeMockData(jsonData: [String: Any]) -> Data {
        try! JSONSerialization.data(withJSONObject: jsonData)
    }
}
