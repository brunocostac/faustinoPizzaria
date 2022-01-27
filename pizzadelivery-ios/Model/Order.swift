//
//  Order.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 19/01/22.
//

import Foundation

struct Order: Decodable {
    let items: [ItemOrder]
    let address: String
    let status: String
    let subTotal: Double
    let total: Double
    let paymentMethod: String
    let orderId: Int
    let customerName: String
    let dateWasRequest: String
    let dateCompletion: String
    
    init(items: [ItemOrder], address: String, status: String, subTotal: Double, total: Double, paymentMethod: String, orderId: Int, customerName: String, dateWasRequest: String, dateCompletion: String) {
        self.items = items
        self.address = address
        self.status = status
        self.subTotal = subTotal
        self.total = total
        self.paymentMethod = paymentMethod
        self.orderId = orderId
        self.customerName = customerName
        self.dateWasRequest = dateWasRequest
        self.dateCompletion = dateCompletion
    }
}
