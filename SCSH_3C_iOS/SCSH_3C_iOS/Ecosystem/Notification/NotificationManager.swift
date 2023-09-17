//
//  NotificationManager.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/8/24.
//

import UserNotifications

protocol NotificationManagerType {
    static var shared: NotificationManagerType { get }
    func requestAuthorization()
    func addNotification(title: String, body: String)
}

class NotificationManager: NSObject, NotificationManagerType {
    // thread-safe
    static let shared: NotificationManagerType = NotificationManager(factory: NotificationFactory())

    private let factory: NotificationFactoryType
    
    ///
    /// ⚠️⚠️⚠️ DO NOT CALL THE CONSTRUCTOR DIRECTLY.
    /// Instead, access the instace through the `shared`.
    ///
    init(factory: NotificationFactoryType) {
        self.factory = factory
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (isSuccessful, error) in
            // TODO: Error handeling
        }
    }
    
    func addNotification(title: String, body: String) {
        let notificationRequest = factory.generate(title: title, body: body)
        
        UNUserNotificationCenter.current().add(notificationRequest)
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .list, .sound, .banner])
    }
}
