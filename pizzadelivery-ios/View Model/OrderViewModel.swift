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
    func orderViewModel(at indexPath: Int) -> OrderViewModel {
        return orderViewModel[indexPath]
    }
}

extension OrderListViewModel {
    var count: Int {
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
