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

    @State var selectedTab = 0
    
    var body: some Scene {
        WindowGroup {
            CoordinatorFacade.view(for: .main(selectedTab: selectedTab))
                .environment(\.colorScheme, .light)
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
