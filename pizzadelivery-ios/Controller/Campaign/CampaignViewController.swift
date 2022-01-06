//
//  CampaignViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import UIKit

class CampaignViewController: UIViewController, CampaignBaseCoordinated {
    var coordinator: CampaignBaseCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
    // MARK: - Initialization
    
    required init(coordinator: CampaignBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
