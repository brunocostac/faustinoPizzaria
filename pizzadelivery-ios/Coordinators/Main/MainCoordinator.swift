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
    //lazy var orderCoordinator: OrderBaseCoordinator = OrderCoordinator()
    //lazy var campaignCoordinator: PromotionBaseCoordinator = CampaignCoordinator()
    
    func start() -> UIViewController {
        let menuViewController = menuCoordinator.start()
        menuCoordinator.parentCoordinator = self
        menuViewController.tabBarItem = UITabBarItem(title: "Cardápio", image: UIImage(systemName: "homekit"), tag: 0)
        
       // let pedidoViewController = pedidoCoordinator.start()
        //pedidoCoordinator.parentCoordinator = self
       // pedidoViewController.tabBarItem = UITabBarItem(title: "Pedidos", image: UIImage(systemName: "doc.plaintext"), tag: 1)
    
       (rootViewController as? UITabBarController)?.viewControllers = [menuViewController]
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
