//
//  ItemOrder.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 21/01/22.
//

import Foundation

struct ItemOrder: Decodable, Equatable {
    let name: String
    let itemId: String
    let quantity: Int
    let price: Double
    let comment: String
}
