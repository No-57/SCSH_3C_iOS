//
//  ThemeCoreDataFacade.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/12/3.
//

import Foundation
import Combine

public protocol ThemeCoreDataFacadeType {
    
    func get(type: String) -> AnyPublisher<[Theme], Error>
    
    // delete all the themes have the same `type` as the argument, and then insert.
    func save(themes: [Theme]) -> AnyPublisher<Void, Error>
}

public class ThemeCoreDataFacade: ThemeCoreDataFacadeType {
    
    private let themeCoreDataService: ThemeCoreDataServiceType = ThemeCoreDataService(themeCoreDataDao: ThemeCoreDataDao())
    
    public init() {}
    
    public func get(type: String) -> AnyPublisher<[Theme], Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.themeCoreDataService.get(type: type))
        }
        .eraseToAnyPublisher()
    }
    
    public func save(themes: [Theme]) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.themeCoreDataService.save(themes: themes))
        }
        .eraseToAnyPublisher()
    }
}
