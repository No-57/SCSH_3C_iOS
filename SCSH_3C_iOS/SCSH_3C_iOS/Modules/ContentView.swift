//
//  ContentView.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/5/16.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var items: [String]

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.hash) { item in
                    NavigationLink {
                        Text("\(item) it is !")
                    } label: {
                        Text(item)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("SCSH - No.57")
                        .font(.largeTitle)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(items: [
            "iPhone 14",
            "ps5",
            "ps4 pro",
            "switch"
        ])
    }
}
