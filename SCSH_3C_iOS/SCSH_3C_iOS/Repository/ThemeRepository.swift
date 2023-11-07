//
//  ThemeRepository.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/25.
//

import Foundation
import Combine

protocol ThemeRepositoryType {
    func getHomeThemes(isLatest: Bool) -> AnyPublisher<[HomeTheme], Error>
    func getExploreThemes(isLatest: Bool) -> AnyPublisher<[ExploreTheme], Error>
}

class ThemeRepository: ThemeRepositoryType {
    
    // TODO: API design is required.
    
    /// API
    /// Endpoint: `/theme?type=home`
    /// Response: {
    ///     "data": {
    ///         "fields": ["explore", "subject", "special", "3c", "game_point", "distributor_pchome"]
    ///     }
    /// }
    ///
    func getHomeThemes(isLatest: Bool) -> AnyPublisher<[HomeTheme], Error> {
        Future { promise in
            promise(.success([
                .Explore,
                .Subject,
                .Speacial,
                ._3C,
                .GamePoint,
                .Distributor(name: "PChome")
            ]))
        }
        .eraseToAnyPublisher()
    }
    
    // TODO: API design is required.
    
    /// API
    /// Endpoint: `/theme?type=explore`
    /// Response: {
    ///     "data": {
    ///         "fields": ["board", "recent", "brand", "popular", "explore"]
    ///     }
    /// }
    ///
    func getExploreThemes(isLatest: Bool) -> AnyPublisher<[ExploreTheme], Error> {
        Future { promise in
            promise(.success([
                .Board,
                .Recent,
                .Brand,
                .Popular,
                .Explore,
            ]))
        }
        .eraseToAnyPublisher()
    }
}
