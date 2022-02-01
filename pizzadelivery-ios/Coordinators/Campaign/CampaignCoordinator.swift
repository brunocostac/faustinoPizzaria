//
//  CampaignCoordinator.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import Foundation
import UIKit

class CampaignCoordinator: CampaignBaseCoordinator {

    var parentCoordinator: MainBaseCoordinator?
    
    lazy var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        rootViewController = UINavigationController(rootViewController: CampaignViewController(coordinator: self))
        return rootViewController
    }
    
    func moveTo<T: Any>(flow: AppFlow, data: T) {
        switch flow {
        case .campaign(let screen):
            handleCampaignFlow(for: screen, data: data)
        default:
            let date = Date()
            parentCoordinator?.moveTo(flow: flow, data: date)
        }
    }
    
    private func handleCampaignFlow<T: Any>(for screen: CampaignScreen, data: T) {
        switch screen {
        case .campaignScreen:
            print("OK")
        }
    }
    
    func resetToRoot() -> Self {
        navigationRootViewController?.popToRootViewController(animated: false)
        return self
    }
}
