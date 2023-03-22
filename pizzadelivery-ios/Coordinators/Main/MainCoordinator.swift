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
    
    lazy var homeCoordinator: HomeBaseCoordinator = HomeCoordinator()
    lazy var campaignCoordinator: CampaignBaseCoordinator = CampaignCoordinator()
    lazy var orderCoordinator: OrderBaseCoordinator = OrderCoordinator()
    
    func start() -> UIViewController {
        let homeViewController = homeCoordinator.start()
        homeCoordinator.parentCoordinator = self
        homeViewController.tabBarItem = UITabBarItem(title: "Cardápio", image: UIImage(systemName: "menucard"), tag: 0)
        
        let campaignViewController = campaignCoordinator.start()
        campaignCoordinator.parentCoordinator = self
        campaignViewController.tabBarItem = UITabBarItem(title: "Promoções", image: UIImage(systemName: "tag"), tag: 1)
        
        let orderViewController = orderCoordinator.start()
        orderCoordinator.parentCoordinator = self
        orderViewController.tabBarItem = UITabBarItem(title: "Pedidos", image: UIImage(systemName: "doc.plaintext"), tag: 2)
        
        (rootViewController as? UITabBarController)?.viewControllers = [homeViewController, campaignViewController, orderViewController]
    
        return rootViewController
    }
    
    func moveTo<T>(flow: AppFlow, data: T ) { 
        switch flow {
        case .home:
            break
        case .campaign:
            break
        case .order:
            break
        }
    }
}
