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
    
    ///
    /// ```
    /// GET https://{domainhost}/theme/home
    /// ```
    ///
    /// Response: {
    /// ```
    ///     "fields": [
    ///         { "id": ...,
    ///           "name": ...},
    ///     ]
    /// ```
    /// }
    ///
    func getHomeThemes(isLatest: Bool) -> AnyPublisher<[HomeTheme], Error> {
        Future { promise in
            promise(.success([
                .Explore,
                .Subject,
                .Speacial,
                .Product3C,
                .GamePoint,
                .Distributor(name: "PChome")
            ]))
        }
        .eraseToAnyPublisher()
    }
    
    // TODO: API design is required.
    
    ///
    /// ```
    /// GET https://{domainhost}/theme/explore
    /// ```
    ///
    /// Response: {
    /// ```
    ///     "fields": [
    ///         { "id": ...,
    ///           "name": ...},
    ///     ]
    /// ```
    /// }
    ///
    func getExploreThemes(isLatest: Bool) -> AnyPublisher<[ExploreTheme], Error> {
        Future { promise in
            promise(.success([
                .Board,
                .Recent,
                .Distributor,
                .Popular,
                .Explore,
            ]))
        }
        .eraseToAnyPublisher()
    }
}
