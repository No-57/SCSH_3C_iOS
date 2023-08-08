//
//  HomeCoordinator.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/8/1.
//

import Foundation
import SwiftUI
import Persistence

class HomeCoordinator: HomeCoordinatorType {
    
    func start() -> HomeView {
        let productRepository = ProductRepository(productMapper: ProductModelMapper(),
                                                  moyaNetworkFacade: MoyaNetworkFacade(),
                                                  productCoreDataService: ProductCoreDataService())
        let viewModel = HomeViewModel(coordinator: self, productRepository: productRepository)
        
        return HomeView(viewModel: viewModel)
    }
}
