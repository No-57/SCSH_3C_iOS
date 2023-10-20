//
//  HomeCoordinatorType.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/8/1.
//

import Foundation
import SwiftUI

protocol HomeCoordinatorType: CoordinatorType {
    func presentNotificationPermissionDailog(completion: (Bool) -> Void)
}
