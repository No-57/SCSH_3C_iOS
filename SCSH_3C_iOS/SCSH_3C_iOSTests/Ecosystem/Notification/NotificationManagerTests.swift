//
//  NotificationManagerTests.swift
//  SCSH_3C_iOSTests
//
//  Created by 辜敬閎 on 2023/9/17.
//

import XCTest
@testable import SCSH_3C_iOS

final class NotificationManagerTests: XCTestCase {

    var sut: NotificationManager!
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    ///
    /// Test Add Notification works correctly.
    ///
    /// Expect:
    ///     1. title: `This is a title !`
    ///     2. body : `This is a Body !`
    ///
    /// Condition:
    ///     1. func Add Notification parameters
    ///         a. title: `This is a title !`
    ///         b. body : `This is a Body !`
    ///
    ///     2. factory returns
    ///         a. title: `This is a title !`
    ///         b. body : `This is a Body !`
    ///
    func testAddNotificationWorksCorrectly() {
        // mock
        let mockTitle = "This is a title !"
        let mockBody = "This is a Body !"
        let mockNotificationRequest = makeMockNotificationRequest(title: mockTitle, body: mockBody)
        let mockNotificationCenterProxy = MockNotificationCenterProxy()
        
        // sut
        sut = makeSUT(factory: MockNotificationFactory(mockNotificationRequest: mockNotificationRequest),
                      proxy: mockNotificationCenterProxy)
        
        sut.addNotification(title: mockTitle, body: mockBody)
        
        XCTAssertNotNil(mockNotificationCenterProxy.addedRequest)
        XCTAssertEqual(mockNotificationCenterProxy.addedRequest?.content.title, mockTitle)
        XCTAssertEqual(mockNotificationCenterProxy.addedRequest?.content.body, mockBody)
    }
    
    private func makeSUT(factory: NotificationFactoryType, proxy: NotificationCenterProxyType) -> NotificationManager {
        NotificationManager(factory: factory, notificationCenter: proxy)
    }
    
    private func makeMockNotificationRequest(title: String, body: String) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        return UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    }
}

// MARK: Mock object
class MockNotificationFactory: NotificationFactoryType {
    
    private let mockNotificationRequest: UNNotificationRequest
    
    init(mockNotificationRequest: UNNotificationRequest) {
        self.mockNotificationRequest = mockNotificationRequest
    }
    
    func generate(identifier: String, title: String, body: String, triggerInterval: TimeInterval) -> UNNotificationRequest {
        mockNotificationRequest
    }
}

class MockNotificationCenterProxy: NotificationCenterProxyType {
    var delegate: UNUserNotificationCenterDelegate?
    
    var addedRequest: UNNotificationRequest?

    func add(_ request: UNNotificationRequest) {
        addedRequest = request
    }
    
    func requestAuthorization(options: UNAuthorizationOptions, completion: @escaping (Bool, Error?) -> Void) {
        
    }
}
