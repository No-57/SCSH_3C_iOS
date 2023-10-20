//
//  CoordinatorType.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/20.
//

import SwiftUI
import UIKit

protocol CoordinatorType {
    func startSwiftUI() -> AnyView
    func startUIKit() -> UIViewController
}

extension CoordinatorType {
    func startSwiftUI() -> AnyView {
        fatalError("SwiftUI is not supported")
    }
    
    func startUIKit() -> UIViewController {
        fatalError("UIKit is not supported")
    }
}
