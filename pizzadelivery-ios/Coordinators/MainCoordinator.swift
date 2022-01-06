//
//  MainCoordinator.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import Foundation
import UIKit

class MainCoordinator: MainBaseCoordinator {
    var parentCoordinator: MainBaseCoordinator?
    var rootViewController: UIViewController  = UITabBarController()
    
    func start() -> UIViewController {
        <#code#>
    }
    
    func moveTo(flow: AppFlow, userData: [String : Any]?) {
        <#code#>
    }
}
