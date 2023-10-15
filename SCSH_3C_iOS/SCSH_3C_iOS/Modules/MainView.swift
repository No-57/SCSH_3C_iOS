//
//  MainView.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/14.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int

    init(selectedTab: Int) {
        self._selectedTab = State(initialValue: selectedTab)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeCoordinator().start()
                .tabItem {
                    Image(systemName: "house")
                    Text("去比價")
                }
                .tag(0)
            
            // TODO: 我的最愛 implement.
            Text("我的最愛")
                .tabItem {
                    Image(systemName: "heart")
                    Text("我的最愛")
                }
                .tag(1)

            // TODO: 推薦 implement.
            Text("推薦")
                .tabItem {
                    Image(systemName: "hand.thumbsup")
                    Text("推薦")
                }
                .tag(2)

            // TODO: 通知中心 implement.
            Text("通知中心")
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("通知中心")
                }
                .tag(3)

            // TODO: 會員中心 implement.
            Text("會員中心")
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("會員中心")
                }
                .tag(4)
        }
        .onChange(of: selectedTab) { newValue in
            // TODO: implement if needed.
            print("Selected tab changed to: \(newValue)")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(selectedTab: 2)
    }
}
