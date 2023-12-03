//
//  HomeThemeTransformStrategy.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/12/3.
//

import Persistence

class HomeThemeTransformStrategy: ThemeTransformStrategyType {
    func transform<T: ThemeType>(themes: [Persistence.Theme]) -> [T] {
        themes
            .filter { $0.type == HomeTheme.type }
            .compactMap { [weak self] theme -> HomeTheme? in
                guard let self = self, let code = theme.code else { return nil }
                
                return self.getHomeTheme(code: code)
            }
            .compactMap { $0 as? T }
    }
    
    private func getHomeTheme(code: String) -> HomeTheme? {
        switch code {
        case "explore": return .Explore
        
        case "subject": return .Subject
        
        case "product_3C": return .Product3C
            
        case "special": return .Special
            
        case "game_point": return .GamePoint
            
        default:
            return parseToDistributor(code: code)
        }
    }
    
    private func parseToDistributor(code: String) -> HomeTheme? {
        let subStrings = code.split(separator: "_")
        
        guard subStrings.count == 2,
              subStrings[0] == "distributor" else {
            return nil
        }
        
        let name = String(subStrings[1])
        
        return .Distributor(name: name)
    }
}
