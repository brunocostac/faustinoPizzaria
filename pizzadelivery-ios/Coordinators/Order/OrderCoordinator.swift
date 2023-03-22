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
        rootViewController = UINavigationController(rootViewController: OrderHistoryViewController(coordinator: self))
        return rootViewController
    }
    
    func moveTo<T: Any>(flow: AppFlow, data: T) {
        switch flow {
        case .order(let screen):
            handleOrderFlow(for: screen, data: data)
        default:
            parentCoordinator?.moveTo(flow: flow, data: data)
        }
    }
    
    private func handleOrderFlow<T: Any>(for screen: OrderScreen, data: T) {
        switch screen {
        case .lastOrdersScreen:
            break
        case .detailsScreen:
            break
        case .confirmationScreen:
            break
        }
    }
    
    func resetToRoot() -> Self {
        navigationRootViewController?.popToRootViewController(animated: false)
        return self
    }
}
