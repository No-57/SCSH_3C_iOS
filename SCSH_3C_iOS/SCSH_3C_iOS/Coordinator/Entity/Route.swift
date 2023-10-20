//
//  Route.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/20.
//

import Foundation

enum Route: Hashable {
    case main(selectedTab: Int)
    case home
    case search
    case cart
    case message
}
