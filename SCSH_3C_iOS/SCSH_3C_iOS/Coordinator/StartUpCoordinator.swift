
//
//  StartUpCoordinator.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/8/1.
//

import Foundation
import SwiftUI

class StartUpCoordinator: CoordinatorType {
    private let selectedTab: Int
    
    init(selectedTab: Int) {
        self.selectedTab = selectedTab
    }
    
    func startSwiftUI() -> AnyView {
        AnyView(MainView(selectedTab: selectedTab))
    }
}
