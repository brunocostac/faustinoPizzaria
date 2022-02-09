//
//  ItemOrderViewModel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 27/01/22.
//

import Foundation

struct ItemOrderListViewModel {
    var itemOrderViewModel: [ItemOrderViewModel]
    
    init() {
        self.itemOrderViewModel = [ItemOrderViewModel]()
    }
}

struct ItemOrderViewModel: Equatable, Decodable {
    var name: String
    var itemId: Int64
    var price: Double
    var quantity: Int64
    var comment: String
    
    init(itemOrder: ItemOrder) {
        self.name = itemOrder.name!
        self.itemId = itemOrder.itemId
        self.price = itemOrder.price
        self.quantity = itemOrder.quantity
        self.comment = itemOrder.comment!
    }
    
    init(name: String, itemId: Int64, price: Double, quantity: Int64, comment: String) {
        self.name = name
        self.itemId = itemId
        self.price = price
        self.quantity = quantity
        self.comment = comment
    }
}
