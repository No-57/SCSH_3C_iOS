
//
//  StartUpCoordinator.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/8/1.
//

import Foundation
import SwiftUI

class StartUpCoordinator {
    func start(with tab: Int) -> some View {
        NavigationView {
            VStack(spacing: 5) {
                HeaderView()
                FooterView(selectedTab: tab)
            }
        }
    }
}
