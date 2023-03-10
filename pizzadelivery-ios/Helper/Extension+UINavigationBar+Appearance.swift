//
//  Extension+UINavigationBar+Appearance.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 10/03/23.
//

import UIKit

extension UINavigationBar {
    
    static func setGlobalAppearance() {
        UINavigationBar.appearance().tintColor = UIColor.red
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "back_arrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "back_arrow")
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .normal)
    }
}
