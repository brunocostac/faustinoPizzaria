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
        case .dishDetailsScreen:
            guard let title = userData?["title"] as? String else { return }
            goToDishDetailsScreenWith(title: title)
        case .cartScreen:
            goToCartScreenWith()
        case .paymentScreen:
            goToPaymentScreen()
        case .deliveryLocationScreen:
            goToDeliveryLocationScreen()
        }
    }
    
    func goToDishDetailsScreenWith(title: String) {
        let dishDetailsViewController = DishDetailsViewController(coordinator: self)
        dishDetailsViewController.title = title
        navigationRootViewController?.pushViewController(dishDetailsViewController, animated: true)
    }
    
    func goToCartScreenWith() {
        let cartViewController = CartViewController(coordinator: self)
        navigationRootViewController?.pushViewController(cartViewController, animated: true)
    }
    
    func goToPaymentScreen() {
        let paymentViewController = PaymentViewController(coordinator: self)
        navigationRootViewController?.pushViewController(paymentViewController, animated: true)
    }
    
    func goToDeliveryLocationScreen() {
        let deliveryLocationViewController = DeliveryLocationViewController(coordinator: self)
        navigationRootViewController?.pushViewController(deliveryLocationViewController, animated: true)
    }
    
    func resetToRoot() -> Self {
        navigationRootViewController?.popToRootViewController(animated: false)
        return self
    }
}
