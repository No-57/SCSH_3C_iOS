//
//  Theme.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/25.
//

import Foundation

protocol ThemeType {
    static var type: String { get }
}

enum HomeTheme: ThemeType, Equatable {
    case Explore
    case Subject
    case Product3C
    case Special
    case GamePoint
    case Distributor(name: String)
    
    // Use for save, query, filter in `Persistence` and `Network` modules.
    static let type = "home"
}

enum ExploreTheme: ThemeType {
    case Board
    case Recent
    case Distributor
    case Popular
    case ProductExplore
    
    // Use for save, query, filter in `Persistence` and `Network` modules.
    static let type = "explore"
}
