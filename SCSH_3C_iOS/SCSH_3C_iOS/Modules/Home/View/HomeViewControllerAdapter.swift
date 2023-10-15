//
//  HomeViewControllerAdapter.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/16.
//

import SwiftUI

struct HomeViewControllerAdapter: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = HomeViewController
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> HomeViewController {
        HomeViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
        // update if needed
    }
}
