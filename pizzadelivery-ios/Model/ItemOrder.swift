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
    var quantity: Int
    let price: Double
    let comment: String
    
    init(name: String, itemId: String, quantity: Int, price: Double, comment: String) {
        self.name = name
        self.itemId = itemId
        self.quantity = quantity
        self.price = price
        self.comment = comment
    }
    
    mutating func increaseQuantity() {
        self.quantity += 1
    }
    
    mutating func decreaseQuantity() {
        if self.quantity > 1 {
            self.quantity -= 1
        }
    }
    
    func calculateTotal() -> String {
        let total = String(format: "%.2f", self.price * Double(self.quantity))
        return total.replacingOccurrences(of: ".", with: ",")
    }
}
