//
//  HomeCoordinatorType.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/8/1.
//

import Foundation
import SwiftUI
import Combine

protocol HomeCoordinatorType: CoordinatorType {
    var navigate: PassthroughSubject<Route, Error> { get set }
    
    func presentNotificationPermissionDailog(completion: (Bool) -> Void)
    func requestSearchNavigation()
    func requestCartNavigation()
    func requestMessageNavigation()
}
