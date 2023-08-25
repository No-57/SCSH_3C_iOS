//
//  NotificationManager.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/8/24.
//

import UserNotifications

protocol NotificationManagerType {
    static var shared: Self { get }
    func requestAuthorization()
    func addNotification(title: String, body: String)
}

final class NotificationManager: NSObject, NotificationManagerType {
    static var shared: NotificationManager = NotificationManager()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (isSuccessful, error) in
            // TODO: Error handeling
        }
    }
    
    func addNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .list, .sound, .banner])
    }
}
