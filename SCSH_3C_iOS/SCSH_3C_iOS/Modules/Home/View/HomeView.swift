//
//  HomeView.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/5/16.
//

import SwiftUI
import Combine

struct HomeView: View {

    @ObservedObject
    private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack(spacing: 0) {
                HomeHeaderView(viewModel: viewModel)
                HomeViewControllerAdapter(viewModel: viewModel)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(coordinator: HomeCoordinator()))
    }
}
