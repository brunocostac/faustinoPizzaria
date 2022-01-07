//
//  MenuCoordinator.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import Foundation
import UIKit

class MenuCoordinator: MenuBaseCoordinator {

    var parentCoordinator: MainBaseCoordinator?
    
    lazy var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        rootViewController = UINavigationController(rootViewController: MenuViewController(coordinator: self))
        return rootViewController
    }
    
    func moveTo(flow: AppFlow, userData: [String: Any]? = nil) {
        switch flow {
        case .menu(let screen):
            handleMenuFlow(for: screen, userData: userData)
        default:
            parentCoordinator?.moveTo(flow: flow, userData: userData)
        }
    }
    
    private func handleMenuFlow(for screen: MenuScreen, userData: [String: Any]?) {
        switch screen {
        case .menuScreen:
            navigationRootViewController?.popToRootViewController(animated: true)
        case .detailsScreen:
            print("ok")
        case .shoppingCartScreen:
            print("ok")
        case .paymentScreen:
            print("ok")
        case .placeToDeliveryScreen:
            print("ok")
        }
    }
    
    func resetToRoot() -> Self {
        navigationRootViewController?.popToRootViewController(animated: false)
        return self
    }
}
