//
//  CampaignBaseCoordinated.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import Foundation

protocol CampaignBaseCoordinated {
    var coordinator: CampaignBaseCoordinator? { get }
    init(coordinator: CampaignBaseCoordinator)
}
