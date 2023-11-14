//
//  CoordinatorFacade.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/20.
//

import SwiftUI
import UIKit

class CoordinatorFacade {

    static func view(for route: Route) -> AnyView? {
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

        default:
            return nil
        }
        
        return coordinator.startSwiftUI()
    }
    
    static func viewController(for route: Route) -> UIViewController? {
        let coordinator: CoordinatorType
        
        switch route {
        case .explore:
            coordinator = ExploreCoordinator()
            
        case .product(let id):
            // TODO: implement product module.
            let alert = UIAlertController(title: "打開 product 模組", message: id, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "關閉", style: .cancel))
            return alert
            
        case .distributor(let id):
            // TODO: implement distributor module.
            let alert = UIAlertController(title: "打開 Distributor 模組", message: id, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "關閉", style: .cancel))
            return alert
            
        case .web(let url):
            // TODO: implement web view module.
            let alert = UIAlertController(title: "打開 Web 模組", message: url.absoluteString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "關閉", style: .cancel))
            return alert
            
        default:
            return nil
        }
        
        return coordinator.startUIKit()
    }
}
