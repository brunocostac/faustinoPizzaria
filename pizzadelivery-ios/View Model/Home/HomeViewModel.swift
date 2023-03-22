//
//  HomeViewModel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 22/03/23.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didFetchMenu(menuListViewModel: MenuListViewModel)
    func didLoadCartButton(quantity: String?, totalItemOrder: String?, cartButtonIsEnabled: Bool)
}

class HomeViewModel {
    
    var menuListViewModel = MenuListViewModel()
    private var orderViewModel = OrderViewModel()
    private var itemOrderListViewModel = ItemOrderListViewModel()
    
    var delegate: HomeViewModelDelegate?
    
    func viewDidAppear() {
        self.clearViewModels()
        self.fetchMenu()
        self.fetchOrder()
        self.fetchItems()
        self.loadCartButton()
    }
    
    private func fetchMenu() {
        MockApiClient().fetchMenu { (_, menuData) in
            self.menuListViewModel.menuViewModel = menuData.map(MenuViewModel.init)
            self.delegate?.didFetchMenu(menuListViewModel: self.menuListViewModel)
        }
    }
    
    private func loadCartButton() {
        if itemOrderListViewModel.cartButtonIsEnabled {
            let items = itemOrderListViewModel
            self.delegate?.didLoadCartButton(quantity: items.quantity, totalItemOrder:  items.totalItemOrder, cartButtonIsEnabled: true)
        } else {
            self.delegate?.didLoadCartButton(quantity: nil, totalItemOrder: nil, cartButtonIsEnabled: false)
        }
    }
    
    private func clearViewModels() {
        self.itemOrderListViewModel = ItemOrderListViewModel()
        self.orderViewModel = OrderViewModel()
    }
    
    
    private func fetchOrder() {
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
    
   func createOrder() {
        if self.orderViewModel.order == nil {
            self.orderViewModel.createOrder()
        }
    }
}
