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
    
    init(name: String, imageUrl: String, description: String, price: Double) {
        self.name = name
        self.imageUrl = imageUrl
        self.description = description
        self.price = price
    }
}
