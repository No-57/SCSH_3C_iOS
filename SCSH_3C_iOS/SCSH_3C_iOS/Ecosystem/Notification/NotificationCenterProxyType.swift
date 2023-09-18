//
//  NotificationCenterProxyType.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/9/18.
//

import UserNotifications

protocol NotificationCenterProxyType {
    var delegate: UNUserNotificationCenterDelegate? { get set }
    
    func add(_ request: UNNotificationRequest)
    func requestAuthorization(options: UNAuthorizationOptions, completion: @escaping (Bool, Error?) -> Void)
}

extension UNUserNotificationCenter: NotificationCenterProxyType {
    func add(_ request: UNNotificationRequest) {
        add(request, withCompletionHandler: nil)
    }
    
    func requestAuthorization(options: UNAuthorizationOptions, completion: @escaping (Bool, Error?) -> Void) {
        requestAuthorization(options: options, completionHandler: completion)
    }
}
