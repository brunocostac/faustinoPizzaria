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
    
    weak var delegate: HomeViewModelDelegate?
    
    private let apiClient: MockApiClient
    
    init(apiClient: MockApiClient) {
        self.apiClient = apiClient
    }
    
    func viewDidAppear() {
        fetchMenu()
        fetchOrder()
        fetchItems()
    }
    
    private func fetchMenu() {
        apiClient.fetchMenu { [weak self] (_, menuData) in
            guard let self = self else { return }
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
    
    private func fetchOrder() {
        orderViewModel.fetch { [weak self] orderViewModel in
            guard let self = self else { return }
            if let orderVM = orderViewModel {
                self.orderViewModel = orderVM
            }
        }
    }
    
    private func fetchItems() {
        guard let order = orderViewModel.order else { return }
        itemOrderListViewModel.fetchAll(orderViewModel: orderViewModel) { [weak self] itemOrderListVM in
            guard let self = self else { return }
            if let itemOrderListVM = itemOrderListVM {
                self.itemOrderListViewModel = itemOrderListVM
            }
            self.loadCartButton()
        }
    }
    
    func createOrder() {
        if orderViewModel.order == nil {
            orderViewModel.createOrder()
        }
    }
}
