//
//  HomeHeaderView.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/14.
//

import SwiftUI
import Combine

struct HomeHeaderView: View {
    @ObservedObject
    private var viewModel: HomeViewModel
    private let coordinator = HomeCoordinator()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 5) {
                Button(action: {
                    viewModel.logoButtonDidTap.send(())
                }) {
                    Text("Orange")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                }
                .padding(10)
                
                Button(action: {
                    viewModel.searchBarDidTap.send(())
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    Text("搜尋")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(10)
                .background(Color(uiColor: UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 0.3)))
                .cornerRadius(8)
                
                Button(action: {
                    viewModel.messageButtonDidTap.send(())
                }) {
                    Image(systemName: "message")
                        .foregroundColor(.black)
                        .padding(5)
                }
                
                Button(action: {
                    viewModel.cartButtonDidTap.send(())
                }) {
                    Image(systemName: "cart")
                        .foregroundColor(.black)
                        .padding(.trailing)
                }
            }
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView(viewModel: HomeViewModel(coordinator: HomeCoordinator()))
    }
}
