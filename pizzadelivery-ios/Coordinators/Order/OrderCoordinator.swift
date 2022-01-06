//
//  OrderCoordinator.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import Foundation
import UIKit

class OrderCoordinator: OrderBaseCoordinator {

    var parentCoordinator: MainBaseCoordinator?
    
    lazy var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        rootViewController = UINavigationController(rootViewController: OrderViewController(coordinator: self))
        return rootViewController
    }
    
    func moveTo(flow: AppFlow, userData: [String : Any]? = nil) {
        switch flow {
        case .order(let screen):
            handleOrderFlow(for: screen, userData: userData)
        default:
            parentCoordinator?.moveTo(flow: flow, userData: userData)
        }
    }
    
    private func handleOrderFlow(for screen: OrderScreen, userData: [String: Any]?) {
        switch screen {
        case .lastOrdersScreen:
            print("Ok")
        case .detailsScreen:
            print("Ok")
        case .confirmationScreen:
            print("Ok")
        }
    }
    
    func resetToRoot() -> Self {
        navigationRootViewController?.popToRootViewController(animated: false)
        return self
    }
}
