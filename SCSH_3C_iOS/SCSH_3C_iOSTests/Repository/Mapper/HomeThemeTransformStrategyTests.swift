//
//  HomeThemeTransformStrategyTests.swift
//  SCSH_3C_iOSTests
//
//  Created by 辜敬閎 on 2023/12/3.
//

import XCTest
import Persistence
import CoreData
@testable import SCSH_3C_iOS

final class HomeThemeTransformStrategyTests: XCTestCase {

    var sut: HomeThemeTransformStrategy!

    ///
    /// Test transform logic.
    ///
    /// Expect:
    ///     1. count = 3
    ///     2. ExploreTheme.`Explore`
    ///     3. ExploreTheme.`Special`
    ///     3. ExploreTheme.`Distributor(Fabj)`
    ///
    /// Condition:
    ///     1. Theme(id: `1`, type: `home`, code: `explore`)
    ///     2. Theme(id: `2`, type: `explore`, code: `board`)
    ///     3. Theme(id: `3`, type: `home`, code: `Special`)
    ///     4. Theme(id: `4`, type: `home`, code: `special`)
    ///     5. Theme(id: `5`, type: `home`, code: `distributor_`)
    ///     6. Theme(id: `6`, type: `home`, code: `distributor_Fabj`)
    ///
    func testTransformLogic() throws {
        // sut
        makeSUT()
        
        let context = CoreDataController.shared.container.newBackgroundContext()
        
        let mockTheme_1 = get(id: 1, type: "home", code: "explore", context: context)
        let mockTheme_2 = get(id: 2, type: "explore", code: "board", context: context)
        let mockTheme_3 = get(id: 3, type: "home", code: "Special", context: context)
        let mockTheme_4 = get(id: 4, type: "home", code: "special", context: context)
        let mockTheme_5 = get(id: 5, type: "home", code: "distributor_", context: context)
        let mockTheme_6 = get(id: 6, type: "home", code: "distributor_Fabj", context: context)
        
        let result: [HomeTheme] = sut.transform(themes: [mockTheme_1, mockTheme_2, mockTheme_3, mockTheme_4, mockTheme_5, mockTheme_6])
        
        XCTAssertEqual(result.count, 3)
        
        XCTAssertEqual(result[0], .Explore)
        XCTAssertEqual(result[1], .Special)
        XCTAssertEqual(result[2], .Distributor(name: "Fabj"))
    }
    
    private func get(id: Int64, type: String, code: String, context: NSManagedObjectContext) -> Theme {
        let theme = Theme(context: context)
        theme.id = id
        theme.type = type
        theme.code = code
        
        return theme
    }
        
    private func makeSUT() {
        sut = HomeThemeTransformStrategy()
    }

}
