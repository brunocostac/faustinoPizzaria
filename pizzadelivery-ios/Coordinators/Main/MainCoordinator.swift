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
    lazy var menuCoordinator: MenuBaseCoordinator = MenuCoordinator()
    lazy var campaignCoordinator: CampaignBaseCoordinator = CampaignCoordinator()
    lazy var orderCoordinator: OrderBaseCoordinator = OrderCoordinator()
    
    func start() -> UIViewController {
        let menuViewController = menuCoordinator.start()
        menuCoordinator.parentCoordinator = self
        menuViewController.tabBarItem = UITabBarItem(title: "Cardápio", image: UIImage(systemName: "homekit"), tag: 0)
        
        let campaignViewController = campaignCoordinator.start()
        campaignCoordinator.parentCoordinator = self
        campaignViewController.tabBarItem = UITabBarItem(title: "Promoção", image: UIImage(systemName: "tag"), tag: 1)
        
        let orderViewController = orderCoordinator.start()
        orderCoordinator.parentCoordinator = self
        orderViewController.tabBarItem = UITabBarItem(title: "Pedidos", image: UIImage(systemName: "doc.plaintext"), tag: 2)
        
       (rootViewController as? UITabBarController)?.viewControllers = [menuViewController, campaignViewController, orderViewController]
        return rootViewController
    }
    
    func moveTo(flow: AppFlow, userData: [String : Any]? ) {
        switch flow {
           case .menu:
             print("ok")
           case .campaign:
             print("ok")
           case .order:
             print("ok")
        }
    }
}
