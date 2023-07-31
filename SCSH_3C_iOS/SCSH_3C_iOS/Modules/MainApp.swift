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
    private let startUpCoordinator = StartUpCoordinator()
    
    var body: some Scene {
        WindowGroup {
            startUpCoordinator.start()
        }
    }
}
