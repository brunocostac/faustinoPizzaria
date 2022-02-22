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
    func orderAtIndex(_ index: Int) -> OrderViewModel {
        return self.orderViewModel[index]
    }
}

extension OrderListViewModel {
    var numberOfSections: Int {
        return 1
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
        return "Data do pedido: \(String(describing: self.order.dateWasRequest!.getFormattedDate(format: "dd-MM-yyyy HH:mm:ss")))"
    }
}
