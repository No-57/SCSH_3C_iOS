//
//  Theme.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/25.
//

import Foundation

protocol ThemeType {}

enum HomeTheme: ThemeType {
    case Explore
    case Subject
    case Product3C
    case Special
    case GamePoint
    case Distributor(name: String)
}

enum ExploreTheme: ThemeType {
    case Board
    case Recent
    case Distributor
    case Popular
    case Explore
}
