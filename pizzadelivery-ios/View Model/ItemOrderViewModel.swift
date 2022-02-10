//
//  ItemOrderViewModel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 27/01/22.
//

import Foundation

class ItemOrderListViewModel {
    var itemOrderViewModel: [ItemOrderViewModel]
    
    init(itemsOrder: [ItemOrderViewModel]) {
        self.itemOrderViewModel = itemsOrder
    }
}

extension ItemOrderListViewModel {
    
    var totalPrice: String {
        var total: Double = 0.0
        for item in itemOrderViewModel {
            total += Double(item.quantity) * item.price
        }
        return String(format: "%.2f", total)
    }
    
    var quantity: String {
        var total: Int = 0
        for item in itemOrderViewModel {
            total += Int(item.quantity)
        }
        return String(describing: total)
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
