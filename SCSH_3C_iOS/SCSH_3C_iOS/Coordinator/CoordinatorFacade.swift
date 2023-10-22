//
//  CoordinatorFacade.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/20.
//

import SwiftUI

class CoordinatorFacade {
    static func view(for route: Route) -> AnyView {
        let coordinator: CoordinatorType
        
        switch route {
        case .main(let selectedTab):
            coordinator = StartUpCoordinator(selectedTab: selectedTab)
            
        case .home:
            coordinator = HomeCoordinator()
            
        case .search:
            // TODO: implement search module.
            return AnyView(Text("Search View!"))
            
        case .cart:
            // TODO: implement cart module.
            return AnyView(Text("Cart View!"))
            
        case .message:
            // TODO: implement message module.
            return AnyView(Text("Message View!"))
        }
        
        return coordinator.startSwiftUI()
    }
}
