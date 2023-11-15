//
//  ExploreCoordinatorType.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/20.
//

import Foundation
import Combine

protocol ExploreCoordinatorType: CoordinatorType {
    var navigate: PassthroughSubject<Route, Never> { get set }
    func requestWebNavigation(url: URL)
    func requestDistributorNavigation(id: String)
    func requestProductNavigation(id: String)
}
