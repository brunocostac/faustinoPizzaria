//
//  OrderViewModel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 27/01/22.
//

import Foundation

class OrderListViewModel {
    var orderViewModel: [OrderViewModel]
    
    init(orders: [OrderViewModel]) {
        self.orderViewModel = orders
    }
}

extension OrderListViewModel {
    func orderAtIndex(_ index: Int) -> OrderViewModel {
        return self.orderViewModel[index]
    }
}

extension OrderListViewModel {
    var numberOfSections: Int {
        if orderViewModel.isEmpty {
            return 0
        } else {
            return 1
        }
    }
    var numberOfRowsInSection: Int {
        return self.orderViewModel.count
    }
}

struct OrderViewModel {
    let order: Order
}

extension OrderViewModel {
    init(_ order: Order) {
        self.order = order
    }
}

extension OrderViewModel {
    var dateRequest: String {
        return "\(self.order.dateWasRequest!.getFormattedDate(format: "dd/MM/yyyy HH:mm"))"
    }
    
    var dateCompletion: String {
        return "\(self.order.dateCompletion!.getFormattedDate(format: "dd/MM/yyyy HH:mm"))"
    }
    
    func isValidAddress() -> Bool {
        if self.order.address != "" &&  self.order.neighborhood != "" && self.order.customerName != "" {
            return true
        } else {
            return false
        }
    }
}
