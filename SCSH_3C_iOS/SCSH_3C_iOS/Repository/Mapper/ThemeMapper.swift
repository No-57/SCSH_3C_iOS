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
            return transformToHomeTheme(persistenceThemes: themes) as? [T] ?? []
            
        } else if T.self == ExploreTheme.self {
            return transformToExploreTheme(persistenceThemes: themes) as? [T] ?? []
        }
        
        return []
    }
    
    private func transformToHomeTheme(persistenceThemes themes: [Persistence.Theme]) -> [HomeTheme] {
        themes
            .compactMap { theme -> HomeTheme? in
                
                // TODO: refactor it.
                switch theme.code {
                case "explore": return .Explore
                
                case "subject": return .Subject
                
                case "product_3C": return .Product3C
                    
                case "special": return .Special
                    
                case "game_point": return .GamePoint
                    
                default:
                    guard let subStrings = theme.code?.split(separator: "_"),
                          subStrings.count == 2,
                          subStrings[0] == "distributor" else {
                        return nil
                    }
                    
                    return .Distributor(name: String(subStrings[1]))
                }
            }
    }
    
    private func transformToExploreTheme(persistenceThemes themes: [Persistence.Theme]) -> [ExploreTheme] {
        themes
            .compactMap { theme -> ExploreTheme? in
                
                // TODO: refactor it.
                guard theme.type == "explore" else {
                    return nil
                }

                // TODO: refactor it.
                switch theme.code {
                case "board": return .Board

                case "recent": return .Recent

                case "distributor": return .Distributor

                case "popular": return .Popular

                case "explore": return .Explore

                default:
                    return nil
                }
            }
    }
}
