//
//  ExploreBoard.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/22.
//

import Foundation

struct ExploreBoard {
    let id: String
    let imageUrl: URL?
    
    // TODO: refactor to enum in Action Module.
    let actionType: String?

    // TODO: refactor to `Action`.
    let action: URL?
}

extension ExploreBoard {
    // Use for save, query, filter in `Persistence` and `Network` modules.
    static let code = "explore_carousel_board"
}
