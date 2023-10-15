//
//  ContentView.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/5/16.
//

import SwiftUI

struct HomeView: UIViewControllerRepresentable {
    
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
