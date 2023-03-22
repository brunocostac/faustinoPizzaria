//
//  CartViewModel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 21/03/23.
//

import Foundation

class CartViewModel {
    
    var orderViewModel = OrderViewModel()
    var itemOrderListViewModel = ItemOrderListViewModel()
    
    let section = ["Resumo do Pedido", "Local de entrega"]
    
    func viewDidAppear() {
        self.fetchOrder()
        self.fetchItems()
    }
    
    func fetchOrder() {
        self.orderViewModel.fetch { orderViewModel in
            if let orderVM = orderViewModel {
                self.orderViewModel = orderVM
            }
        }
    }
    
    private func fetchItems() {
        if self.orderViewModel.order != nil {
            self.itemOrderListViewModel.fetchAll(orderViewModel: self.orderViewModel) { itemOrderListVM in
                if let itemOrderListVM = itemOrderListVM {
                    self.itemOrderListViewModel = itemOrderListVM
                }
            }
        }
    }
}
