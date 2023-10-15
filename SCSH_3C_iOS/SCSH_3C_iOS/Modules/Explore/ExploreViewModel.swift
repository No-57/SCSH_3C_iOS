//
//  ExploreViewModel.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/9.
//

import Foundation
import Combine

class ExploreViewModel: ObservableObject {
    @Published var sections = ["Board", "Recent", "Brand", "Popular", "Explore"]
}
