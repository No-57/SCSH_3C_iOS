//
//  ThemeCoreDataService.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/12/1.
//

import Combine

protocol ThemeCoreDataServiceType {
    func get(type: String) -> Result<[Theme], Error>
    func save(themes: [Theme]) -> Result<Void, Error>
}

class ThemeCoreDataService: ThemeCoreDataServiceType {
    
    private let themeCoreDataDao: ThemeCoreDataDaoType
    
    init(themeCoreDataDao: ThemeCoreDataDaoType) {
        self.themeCoreDataDao = themeCoreDataDao
    }
    
    func get(type: String) -> Result<[Theme], Error> {
 
        do {
            let result = try themeCoreDataDao.get(type: type)
            return .success(result)
            
        } catch {
            print("❌❌❌ ThemeCoreDataService get fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
    
    func save(themes: [Theme]) -> Result<Void, Error> {
        
        let distinctTypes = Array(Set(themes.compactMap(\.type)))
        
        do {
            
            try themeCoreDataDao.delete(types: distinctTypes)
            try themeCoreDataDao.insert(themes: themes)
            
            return .success(())
            
        } catch {
            print("❌❌❌ ThemeCoreDataService save fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
}
