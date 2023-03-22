//
//  Enums.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import Foundation

enum AppFlow {
    case home(HomeScreen)
    case order(OrderScreen)
    case campaign(CampaignScreen)
}

enum HomeScreen {
    case homeScreen
    case dishDetailsScreen
    case cartScreen
    case paymentScreen
    case deliveryLocationScreen
}

enum OrderScreen {
    case lastOrdersScreen
    case detailsScreen
    case confirmationScreen
}

enum CampaignScreen {
    case campaignScreen
}

enum ItemOrderStatus: String {
    case create = "Adicionar"
    case update = "Atualizar"
    case remove = "Remover"
}
