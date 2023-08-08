//
//  ContentView.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/5/16.
//

import SwiftUI

struct HomeView: View {
    
    @State private var searchText: String = ""
    
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack {
            // 1. Header
            Text("3C Comparsion")
                .font(.largeTitle)
                .padding()

            // 2. SearchBar
            HStack(spacing: 5) {
                TextField("Enter product name", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText) { newValue in
                        viewModel.searchTextDidChange.send(newValue)
                    }
                
                HStack(spacing: 0) {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark")
                            .font(.title) // Customize the size of the image as desired
                            .foregroundColor(.gray) // Customize the color of the image
                    }
                }
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))

            // 3. ProductList
            if viewModel.productNames.isEmpty {
                Spacer()
            } else {
                List(viewModel.productNames, id: \.self) { item in
                    Text(item)
                }
            }

            // 4. Footer
            Text("No.57 © 2023 All right reserved.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding()
        }
        .onAppear {
            viewModel.viewDidAppear.send(())
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        return HomeCoordinator().start()
    }
}
