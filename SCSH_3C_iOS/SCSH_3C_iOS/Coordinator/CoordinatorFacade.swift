//
//  CoordinatorFacade.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/20.
//

import SwiftUI

class CoordinatorFacade {
    static func view(for route: Route) -> AnyView {
        switch route {
        case .main(let selectedTab):
            return StartUpCoordinator(selectedTab: selectedTab).start()
            
        case .home:
            return HomeCoordinator().start()
        }
    }
}
