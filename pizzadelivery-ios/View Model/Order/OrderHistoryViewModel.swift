//
//  OrderHistoryViewModel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 22/03/23.
//

import Foundation

protocol OrderHistoryViewModelDelegate: AnyObject {
    func didFetchAllOrders()
}

class OrderHistoryViewModel {
    
    var orderListViewModel = OrderListViewModel()
    var itemOrderListViewModel = ItemOrderListViewModel()
    
    var delegate: OrderHistoryViewModelDelegate?
    
    func viewDidAppear() {
        self.fetchAllOrders()
    }
    
    func fetchAllItems(orderViewModel: OrderViewModel) -> ItemOrderListViewModel? {
        itemOrderListViewModel.fetchAll(orderViewModel: orderViewModel) { itemOrderListVM in
            if let itemOrderListVM = itemOrderListVM {
                self.itemOrderListViewModel = itemOrderListVM
            }
        }
        return itemOrderListViewModel
    }
    
    private func fetchAllOrders() {
        self.orderListViewModel.fetchAll{ orders in
            if let ordersListVM = orders {
                self.orderListViewModel = OrderListViewModel(orders: ordersListVM)
                self.delegate?.didFetchAllOrders()
            }
        }
    }
}
