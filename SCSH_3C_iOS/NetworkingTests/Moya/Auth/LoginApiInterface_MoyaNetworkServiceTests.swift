//
//  LoginApiInterface_MoyaNetworkServiceTests.swift
//  NetworkingTests
//
//  Created by 辜敬閎 on 2023/10/2.
//

import XCTest
import Moya
@testable import Networking

final class LoginApiInterface_MoyaNetworkServiceTests: XCTestCase {
    
    var sut: MoyaNetworkService<LoginApiInterface>!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    ///
    /// Test API: `/login` returns successfully.
    ///
    /// Expect:
    ///     1. `success` is executed
    ///     2. code = `9999`
    ///     3. data = `LoginApiModel(accessToken: "eyJhbGciOiJIUzI1NiI", refreshToken: "7eHeBIUjD2gKPX-Es9nA")`
    ///
    /// Condition:
    ///     1. password: 7777
    ///     2. target: vince@gmail.com
    ///     3. statusCode: 201
    ///     4. data: {
    ///             code: 9999,
    ///             data: {
    ///                     "access_token": "eyJhbGciOiJIUzI1NiI",
    ///                     "refresh_token": "7eHeBIUjD2gKPX-Es9nA"
    ///             }
    ///     }
    ///
    func testLoginApiFetchesSuccessWithCode2XXAndCorrectData() {
        // sut
        let loginApiInterface = LoginApiInterface(password: "7777", target: "vince@gmail.com")
        let mockData = makeMockData(jsonData: ["code": 9999, "data": ["access_token": "eyJhbGciOiJIUzI1NiI", "refresh_token": "7eHeBIUjD2gKPX-Es9nA"]])
        makeSUT(loginApiInterface: loginApiInterface, statusCode: 201, data: mockData)
         
        let successIsExecuted = expectation(description: "success")
        
        sut.fetch(success: { outputModel in
            successIsExecuted.fulfill()
            XCTAssertEqual(outputModel.code, 9999)
            XCTAssertEqual(outputModel.data, LoginApiModel(accessToken: "eyJhbGciOiJIUzI1NiI", refreshToken: "7eHeBIUjD2gKPX-Es9nA"))
        }, failure: { (error) in
            XCTFail()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [successIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/login` returns failure.
    ///
    /// Expect:
    ///     1. `failure` is executed
    ///
    /// Condition:
    ///     1. password: 7777
    ///     2. target: vince@gmail.com
    ///     3. statusCOde: 201
    ///     4. data: {
    ///             code: 9999,
    ///             data: {
    ///                     "access_token": "eyJhbGciOiJIUzI1NiI",
    ///                     "refresh_token": "7eHeBIUjD2gKPX-Es9nA"
    ///             }
    ///     }
    ///
    func testLoginApiFetchesFailureWithCode2XXAndWrongData() {
        // sut
        let loginApiInterface = LoginApiInterface(password: "7777", target: "vince@gmail.com")
        let mockData = makeMockData(jsonData: ["code": 9999, "data": ["access_token2": "eyJhbGciOiJIUzI1NiI", "refresh_token": "7eHeBIUjD2gKPX-Es9nA"]])
        makeSUT(loginApiInterface: loginApiInterface, statusCode: 201, data: mockData)
         
        let failureIsExecuted = expectation(description: "failure")
        
        sut.fetch(success: { outputModel in
            XCTFail()
        }, failure: { (error) in
            failureIsExecuted.fulfill()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [failureIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/login` returns successfully.
    ///
    /// Expect:
    ///     1. `success` is executed
    ///     2. code = `9999`
    ///     3. data = `LoginApiModel(accessToken: "eyJhbGciOiJIUzI1NiI", refreshToken: "7eHeBIUjD2gKPX-Es9nA")`
    ///
    /// Condition:
    ///     1. password: 7777
    ///     2. target: vince@gmail.com
    ///     3. statusCode: 301
    ///     4. data: {
    ///             code: 9999,
    ///             data: {
    ///                     "access_token": "eyJhbGciOiJIUzI1NiI",
    ///                     "refresh_token": "7eHeBIUjD2gKPX-Es9nA"
    ///             }
    ///     }
    ///
    func testLoginApiFetchesSuccessWithCode3XXAndCorrectData() {
        // sut
        let loginApiInterface = LoginApiInterface(password: "7777", target: "vince@gmail.com")
        let mockData = makeMockData(jsonData: ["code": 9999, "data": ["access_token": "eyJhbGciOiJIUzI1NiI", "refresh_token": "7eHeBIUjD2gKPX-Es9nA"]])
        makeSUT(loginApiInterface: loginApiInterface, statusCode: 301, data: mockData)
         
        let successIsExecuted = expectation(description: "success")
        
        sut.fetch(success: { outputModel in
            successIsExecuted.fulfill()
            XCTAssertEqual(outputModel.code, 9999)
            XCTAssertEqual(outputModel.data, LoginApiModel(accessToken: "eyJhbGciOiJIUzI1NiI", refreshToken: "7eHeBIUjD2gKPX-Es9nA"))
        }, failure: { (error) in
            XCTFail()
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [successIsExecuted], timeout: 1), .completed)
    }
    
    ///
    /// Test API: `/login` returns failure.
    ///
    /// Expect:
    ///     1. `failure` is executed
    ///     2. data = `ApiError(code: 123, extra: "aaa", message: "whatever")`
    ///
    /// Condition:
    ///     1. password: 7777
    ///     2. target: vince@gmail.com
    ///     3. statusCode: 422
    ///     4. data: {
    ///             code: 123,
    ///             extra: "aaa",
    ///             message: "whatever"
    ///     }
    ///
    func testLoginApiFetchesFailureWithCode4XXAndCorrectData() {
        // sut
        let loginApiInterface = LoginApiInterface(password: "7777", target: "vince@gmail.com")
        let mockData = makeMockData(jsonData: ["code": 123, "extra": "aaa", "message": "whatever"])
        makeSUT(loginApiInterface: loginApiInterface, statusCode: 422, data: mockData)
         
        let failureIsExecuted = expectation(description: "failure")
        
        sut.fetch(success: { outputModel in
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
    /// Test API: `/login` returns failure.
    ///
    /// Expect:
    ///     1. `failure` is executed
    ///     2. data = `ApiError(code: 123, extra: nil, message: "whatever")`
    ///
    /// Condition:
    ///     1. password: 7777
    ///     2. target: vince@gmail.com
    ///     3. statusCode: `522`
    ///     4. data: {
    ///             code: 123,
    ///             extra: nil,
    ///             message: "whatever"
    ///     }
    ///
    func testLoginApiFetchesFailureWithCode5XXAndCorrectData() {
        // sut
        let loginApiInterface = LoginApiInterface(password: "7777", target: "vince@gmail.com")
        let mockData = makeMockData(jsonData: ["code": 123, "extra": nil, "message": "whatever"])
        makeSUT(loginApiInterface: loginApiInterface, statusCode: 522, data: mockData)
         
        let failureIsExecuted = expectation(description: "failure")
        
        sut.fetch(success: { outputModel in
            XCTFail()
        }, failure: { (error) in
            failureIsExecuted.fulfill()
            let apiError = error as? ApiError
            XCTAssertNotNil(apiError)
            XCTAssertEqual(apiError!, ApiError(code: 123, extra: nil, message: "whatever"))
        })
        
        XCTAssertEqual(XCTWaiter.wait(for: [failureIsExecuted], timeout: 1), .completed)
    }
    
    private func makeSUT(loginApiInterface: LoginApiInterface, statusCode: Int, data: Data) {
        
        // For testing, we will use a MoyaProvider with stubbed data
        let stubbingProvider = MoyaProvider<LoginApiInterface>(endpointClosure: { target -> Endpoint in
            
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(statusCode, data) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }, stubClosure: MoyaProvider.immediatelyStub)
        
        sut = MoyaNetworkService(moyaProvider: stubbingProvider, moyaApiInterface: loginApiInterface)
    }
    
    private func makeMockData(jsonData: [String: Any]) -> Data {
        try! JSONSerialization.data(withJSONObject: jsonData)
    }
}
