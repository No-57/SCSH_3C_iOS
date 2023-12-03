//
//  ThemeTransformStrategy.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/12/3.
//

import Persistence

protocol ThemeTransformStrategyType {
    func transform<T: ThemeType>(themes: [Persistence.Theme]) -> [T]
}

class EmptyThemeTransformStrategy: ThemeTransformStrategyType {
    func transform<T>(themes: [Persistence.Theme]) -> [T] where T : ThemeType {
        []
    }
}
