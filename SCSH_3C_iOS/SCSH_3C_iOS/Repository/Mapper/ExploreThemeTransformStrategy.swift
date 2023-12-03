//
//  ExploreThemeTransformStrategy.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/12/3.
//

import Persistence

class ExploreThemeTransformStrategy: ThemeTransformStrategyType {
    func transform<T>(themes: [Persistence.Theme]) -> [T] where T : ThemeType {
        themes
            .filter { $0.type == ExploreTheme.type }
            .compactMap { [weak self] theme -> ExploreTheme? in
                guard let self = self, let code = theme.code else { return nil }
                
                return self.getExploreTheme(code: code)
            }
            .compactMap { $0 as? T }
    }
    
    private func getExploreTheme(code: String) -> ExploreTheme? {
        switch code {
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
