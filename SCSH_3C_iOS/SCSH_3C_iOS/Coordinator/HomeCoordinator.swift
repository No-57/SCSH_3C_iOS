//
//  HomeCoordinator.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/8/1.
//

import Foundation
import SwiftUI

class HomeCoordinator: HomeCoordinatorType {
    
    func start() -> HomeView {
        let productRepository = ProductRepository(productMapper: ProductModelMapper(), moyaNetworkFacade: MoyaNetworkFacade())
        let viewModel = HomeViewModel(coordinator: self, productRepository: productRepository)
        
        return HomeView(viewModel: viewModel)
    }
}
