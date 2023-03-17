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
            guard let previousScreen = data as? MenuScreen else { return }
            goToDeliveryLocationScreen(previousScreen: previousScreen)
        }
    }
    
    func goToDishDetailsScreenWith(_ itemMenuSelected: ItemMenuViewModel) {
        let dishDetailsVC = DishDetailsViewController(coordinator: self)
        dishDetailsVC.itemMenuViewModel = itemMenuSelected
        navigationRootViewController?.pushViewController(dishDetailsVC, animated: true)
    }
    
    func goToCartScreen() {
        let cartVC = CartViewController(coordinator: self)
        navigationRootViewController?.pushViewController(cartVC, animated: true)
    }
    
    func goToPaymentScreen() {
        let paymentVC = PaymentViewController(coordinator: self)
        navigationRootViewController?.pushViewController(paymentVC, animated: true)
    }
    
    func goToDeliveryLocationScreen(previousScreen: MenuScreen) {
        let deliveryLocationVc = DeliveryLocationViewController(coordinator: self)
        deliveryLocationVc.previousScreen = previousScreen
        navigationRootViewController?.pushViewController(deliveryLocationVc, animated: true)
    }
    
    func resetToRoot() -> Self {
        navigationRootViewController?.popToRootViewController(animated: false)
        return self
    }
}
