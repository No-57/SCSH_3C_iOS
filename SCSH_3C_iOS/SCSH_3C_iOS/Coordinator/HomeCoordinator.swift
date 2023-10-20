//
//  HomeCoordinator.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/8/1.
//

import Foundation
import SwiftUI
import Persistence
import Networking
import Combine

class HomeCoordinator: HomeCoordinatorType {
    
    var navigate = PassthroughSubject<Route, Error>()

    private let notificationManager: NotificationManagerType
    
    init(notificationManager: NotificationManagerType = NotificationManager.shared) {
        self.notificationManager = notificationManager
    }
    
    func startSwiftUI() -> AnyView {
        let viewModel = HomeViewModel(coordinator: self)
        
        return AnyView(HomeView(viewModel: viewModel))
    }
    
    func presentNotificationPermissionDailog(completion: (Bool) -> Void) {
        notificationManager.requestAuthorization()
    }
    
    func addNotification(title: String) {
        notificationManager.addNotification(title: "\(title) is tapped!! " , body: "local notification")
    }
    
    func requestSearchNavigation() {
        navigate.send(.search)
    }

    func requestCartNavigation() {
        navigate.send(.cart)
    }
    
    func requestMessageNavigation() {
        navigate.send(.message)
    }
}
