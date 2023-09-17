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

class HomeCoordinator: HomeCoordinatorType {
    
    private let notificationManager: NotificationManagerType
    
    init(notificationManager: NotificationManagerType = NotificationManager.shared) {
        self.notificationManager = notificationManager
    }
    
    func start() -> HomeView {
        let productRepository = ProductRepository(productMapper: ProductModelMapper(),
                                                  moyaNetworkFacade: MoyaNetworkFacade(),
                                                  productCoreDataService: ProductCoreDataService())
        let viewModel = HomeViewModel(coordinator: self, productRepository: productRepository)
        
        return HomeView(viewModel: viewModel)
    }
    
    func presentNotificationPermissionDailog(completion: (Bool) -> Void) {
        notificationManager.requestAuthorization()
    }
    
    func addNotification(title: String) {
        notificationManager.addNotification(title: "\(title) is tapped!! " , body: "local notification")
    }
}
