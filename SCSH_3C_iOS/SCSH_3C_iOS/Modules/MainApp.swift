//
//  MainApp.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/5/16.
//

import SwiftUI
import Combine

@main
struct MainApp: App {
    @Environment(\.scenePhase) private var scenePhase

    private let startUpCoordinator = StartUpCoordinator()
    @State var selectedTab = 0
    
    var body: some Scene {
        WindowGroup {
            startUpCoordinator.start(with: selectedTab)
                .onChange(of: scenePhase) { newScenePhase in
                    switch newScenePhase {
                    case .active:
                        print("App is in the foreground!")
                    case .inactive, .background:
                        break
                    @unknown default:
                        break
                    }
                }
        }
    }
}
