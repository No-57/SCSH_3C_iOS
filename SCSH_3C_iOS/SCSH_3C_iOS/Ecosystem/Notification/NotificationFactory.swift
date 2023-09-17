//
//  NotificationFactory.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/9/17.
//

import UserNotifications

protocol NotificationFactoryType {
    func generate(identifier: String, title: String, body: String, triggerInterval: TimeInterval) -> UNNotificationRequest
}

extension NotificationFactoryType {
    func generate(identifier: String = UUID().uuidString, title: String, body: String, triggerInterval: TimeInterval = 1) -> UNNotificationRequest {
        generate(identifier: identifier, title: title, body: body, triggerInterval: triggerInterval)
    }
}

class NotificationFactory: NotificationFactoryType {
    
    func generate(identifier: String, title: String, body: String, triggerInterval: TimeInterval) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerInterval, repeats: false)
        
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }
    
}
