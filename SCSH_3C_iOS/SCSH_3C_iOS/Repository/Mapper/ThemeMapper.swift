//
//  ThemeMapper.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/12/3.
//

import CoreData
import Persistence
import Networking

protocol ThemeMapperType {
    func transform(networkThemes themes: [Networking.Theme], context: NSManagedObjectContext) -> [Persistence.Theme]
    func transform<T: ThemeType>(persistenceThemes themes: [Persistence.Theme]) -> [T]
}

class ThemeMapper: ThemeMapperType {
    
    private var transformStratrgy: ThemeTransformStrategyType = EmptyThemeTransformStrategy()
    
    func transform(networkThemes themes: [Networking.Theme], context: NSManagedObjectContext) -> [Persistence.Theme] {
        themes.map { theme in
            let persistenceTheme = Persistence.Theme(context: context)
            persistenceTheme.id = Int64(theme.id)
            persistenceTheme.type = theme.type
            persistenceTheme.code = theme.code
            
            return persistenceTheme
        }
    }
    
    func transform<T: ThemeType>(persistenceThemes themes: [Persistence.Theme]) -> [T] {
        
        if T.self == HomeTheme.self {
            transformStratrgy = HomeThemeTransformStrategy()
            
        } else if T.self == ExploreTheme.self {
            transformStratrgy = ExploreThemeTransformStrategy()
            
        } else {
            transformStratrgy = EmptyThemeTransformStrategy()
        }
        
        return transformStratrgy.transform(themes: themes)
    }
}
