//
//  Item.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 18/01/22.
//

import Foundation

struct ItemMenu: Decodable, Equatable {
    let name: String
    let imageUrl: String
    let description: String
    let price: Double
    let itemId: Int
    
    init(name: String, imageUrl: String, description: String, price: Double, itemId: Int) {
        self.name = name
        self.imageUrl = imageUrl
        self.description = description
        self.price = price
        self.itemId = itemId
    }
}
