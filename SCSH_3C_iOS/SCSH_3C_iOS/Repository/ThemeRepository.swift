//
//  ThemeRepository.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/25.
//

import Foundation
import Combine
import Networking
import Persistence
import CoreData

protocol ThemeRepositoryType {
    func getThemes<T: ThemeType>(isLatest: Bool) -> AnyPublisher<[T], Error>
}

class ThemeRepository: ThemeRepositoryType {
    
    private let mapper: ThemeMapperType
    private let themeCoreDataFacade: ThemeCoreDataFacadeType
    private let moyaNetworkFacadeType: MoyaNetworkFacadeType
    
    private let coreDataBackgroundContext = Persistence.CoreDataController.shared.container.newBackgroundContext()
    
    init(mapper: ThemeMapperType, themeCoreDataFacade: ThemeCoreDataFacadeType, moyaNetworkFacadeType: MoyaNetworkFacadeType) {
        self.mapper = mapper
        self.themeCoreDataFacade = themeCoreDataFacade
        self.moyaNetworkFacadeType = moyaNetworkFacadeType
    }
    
    func getThemes<T: ThemeType>(isLatest: Bool) -> AnyPublisher<[T], Error> {
        if isLatest {
            return fetchThemes(type: T.type)
                .flatMap { [weak self] _ -> AnyPublisher<[T], Error> in
                    guard let self = self else {
                        return Empty<[T], Error>().eraseToAnyPublisher()
                    }

                    return self.getThemes()
                }
                .eraseToAnyPublisher()
        }

        return getThemes()
    }

    private func fetchThemes(type: String) -> AnyPublisher<Void, Error> {
        moyaNetworkFacadeType.fetch(apiInterface: ThemeApiInterface(type: type))
            .map(\.data)
            .map { [weak self] themes -> [Persistence.Theme] in
                guard let self = self else {
                    return []
                }

                return self.mapper.transform(networkThemes: themes, context: self.coreDataBackgroundContext)

            }
            .flatMap { [weak self] themes -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }

                return self.themeCoreDataFacade.save(themes: themes)
            }
            .eraseToAnyPublisher()
    }
    
    private func getThemes<T: ThemeType>() -> AnyPublisher<[T], Error> {
        return themeCoreDataFacade.get(type: T.type)
            .map { [weak self] themes -> [T] in
                guard let self = self else {
                    return []
                }

                return self.mapper.transform(persistenceThemes: themes)
            }
            .eraseToAnyPublisher()
    }
}
