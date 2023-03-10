//
//  Extension+UITabBar+Appearance.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 10/03/23.
//

import UIKit

extension UITabBar {
    static func setGlobalAppearance() {
        UITabBar.appearance().tintColor = .red
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().isTranslucent = false
    }
}
