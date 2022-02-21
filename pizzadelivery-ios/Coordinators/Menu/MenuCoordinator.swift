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
    
    func moveTo<T: Any>(flow: AppFlow, data: T) {
        switch flow {
        case .menu(let screen):
            handleMenuFlow(for: screen, data: data)
        default:
            parentCoordinator?.moveTo(flow: flow, data: data)
        }
    }
    
    private func handleMenuFlow<T: Any>(for screen: MenuScreen, data: T?) {
        switch screen {
        case .menuScreen:
            navigationRootViewController?.popToRootViewController(animated: true)
        case .dishDetailsScreen:
            guard let itemMenuVM = data as? ItemMenuViewModel else { return }
            goToDishDetailsScreenWith(itemMenuVM)
        case .cartScreen:
            goToCartScreen()
        case .paymentScreen:
            goToPaymentScreen()
        case .deliveryLocationScreen:
            goToDeliveryLocationScreen()
        }
    }
    
    func goToDishDetailsScreenWith(_ itemMenuSelected: ItemMenuViewModel) {
        let dishDetailsViewController = DishDetailsViewController(coordinator: self)
        dishDetailsViewController.itemMenuViewModel = itemMenuSelected
        navigationRootViewController?.pushViewController(dishDetailsViewController, animated: true)
    }
    
    func goToCartScreen() {
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
