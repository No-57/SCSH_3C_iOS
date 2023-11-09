//
//  ExploreCoordinator.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/20.
//

import SwiftUI
import Combine

class ExploreCoordinator: ExploreCoordinatorType {
    
    var navigate = PassthroughSubject<Route, Never>()
    
    func startUIKit() -> UIViewController {
        let coordinator = ExploreCoordinator()
        let boardRepository = BoardRepository()
        let themeRepository = ThemeRepository()
        let viewModel = ExploreViewModel(coordinator: coordinator, boardRepository: boardRepository, themeRepository: themeRepository)
        return ExploreViewController(viewModel: viewModel)
    }
    
    func requestWebNavigation(url: URL) {
        navigate.send(.web(url: url))
    }
}
