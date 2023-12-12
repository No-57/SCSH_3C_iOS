//
//  ExploreCoordinator.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/20.
//

import SwiftUI
import Combine
import Persistence
import Networking

class ExploreCoordinator: ExploreCoordinatorType {
    
    var navigate = PassthroughSubject<Route, Never>()
    
    func startUIKit() -> UIViewController {
        let coordinator = ExploreCoordinator()
        let boardRepository = BoardRepository(boardCoreDataFacade: BoardCoreDataFacade(), moyaNetworkFacade: MoyaNetworkFacade(), mapper: ExploreBoardMapper())
        let themeRepository = ThemeRepository(mapper: ThemeMapper(), themeCoreDataFacade: ThemeCoreDataFacade(), moyaNetworkFacadeType: MoyaNetworkFacade())
        let distributorRepository = DistributorRepository(mapper: DistributorMapper(), moyaNetworkFacade: MoyaNetworkFacade(), distributorCoreDataFacade: DistributorCoreDataFacade())
        let productRepository = ProductRepository()
        
        let viewModel = ExploreViewModel(coordinator: coordinator, boardRepository: boardRepository, themeRepository: themeRepository, distributorRepository: distributorRepository, productRepository: productRepository)
        return ExploreViewController(viewModel: viewModel)
    }
    
    func requestWebNavigation(url: URL) {
        navigate.send(.web(url: url))
    }
    
    func requestDistributorNavigation(id: String) {
        navigate.send(.distributor(id: id))
    }
    
    func requestProductNavigation(id: String) {
        navigate.send(.product(id: id))
    }
}
