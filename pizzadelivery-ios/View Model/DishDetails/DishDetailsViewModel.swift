//
//  DishDetailsViewModel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 17/03/23.
//

import Foundation
import UIKit

protocol DishDetailsViewModelDelegate: AnyObject {
    func didConfigureMyCartButton(quantity: String, totalItemOrder: String, isHiddenButton: Bool)
    func didConfigureDishDetails(url: String, itemName: String, description: String, price: String, flag: ItemOrderStatus, comment: String)
    func didUpdateQuantityView(quantity: String, decreaseButtonAlpha: Double, decreaseButtonIsEnabled: Bool, flag: ItemOrderStatus, total: String)
    func didGoToHomeScreen()
    func didGoToCartScreen()
}

class DishDetailsViewModel {
    
    // MARK: - Properties
    weak var delegate: DishDetailsViewModelDelegate?
    
    var itemMenuViewModel: ItemMenuViewModel?
    var orderViewModel = OrderViewModel()
    var itemOrderViewModel = ItemOrderViewModel()
    var itemOrderListViewModel = ItemOrderListViewModel()
    var flag: ItemOrderStatus = ItemOrderStatus.create
   
    init(itemMenuViewModel: ItemMenuViewModel?) {
        self.itemMenuViewModel = itemMenuViewModel
    }
    
    func viewDidAppear() {
        self.fetchOrder()
        self.fetchItems()
        self.fetchCurrentItem()
        self.configureDishDetails()
        self.configureMyCartButton()
        self.configureQuantityView()
    }
    
    private func configureQuantityView() {
        if self.flag == ItemOrderStatus.update || self.flag == ItemOrderStatus.remove {
            self.updateQuantityView(quantity: Int(Int64(self.itemOrderViewModel.quantity!)), flag: self.flag)
        }
    }
    
    private func configureMyCartButton() {
        if self.itemOrderListViewModel.cartButtonIsEnabled  {
            self.delegate?.didConfigureMyCartButton(quantity: itemOrderListViewModel.quantity, totalItemOrder: itemOrderListViewModel.totalItemOrder, isHiddenButton: false)
        }
    }
    
    private func configureDishDetails() {
        guard let itemMenu = itemMenuViewModel?.itemMenu else {
            return
        }
        
        if self.flag == ItemOrderStatus.update || self.flag == ItemOrderStatus.remove {
            let total = self.itemOrderViewModel.calculateTotal(Int(itemOrderViewModel.quantity ?? 1), price: Double(itemOrderViewModel.price!))
            
            self.delegate?.didConfigureDishDetails(url: itemMenu.imageUrl, itemName: itemMenu.name, description: itemMenu.description, price: total, flag: self.flag, comment: self.itemOrderViewModel.comment!)
           
        } else {
            self.delegate?.didConfigureDishDetails(url: itemMenu.imageUrl, itemName: itemMenu.name, description: itemMenu.description, price: String(itemMenu.price), flag: self.flag, comment:  self.itemOrderViewModel.comment ?? "")
        }
    }
    
    private func calculateItemTotal(isCreateOrUpdate: Bool, quantity: Int, price: Double) -> String {
        if isCreateOrUpdate {
           return self.itemOrderViewModel.calculateTotal(quantity, price: price)
        } else {
            return self.itemOrderViewModel.calculateTotal(Int(self.itemOrderViewModel.quantity ?? 0), price: price)
        }
    }
    
   func updateQuantityView(quantity: Int, flag: ItemOrderStatus) {
        let isCreateOrUpdate = self.flag == ItemOrderStatus.create || self.flag == ItemOrderStatus.update
        let price = self.itemMenuViewModel?.itemMenu.price
        let total = self.calculateItemTotal(isCreateOrUpdate: isCreateOrUpdate, quantity: quantity, price: price!)
        let flag = self.flag
        let quantity = isCreateOrUpdate ? String(describing: quantity) : "0"
        let decreaseButtonAlpha = isCreateOrUpdate ? 1 : 0.5
        let decreaseButtonIsEnabled = isCreateOrUpdate ? true : false
        
        self.delegate?.didUpdateQuantityView(quantity: quantity, decreaseButtonAlpha: decreaseButtonAlpha, decreaseButtonIsEnabled: decreaseButtonIsEnabled, flag: flag, total: total)
    }
    
    func increaseQuantity(quantity: Int) {
        let newQuantity = quantity + 1
        if self.flag == ItemOrderStatus.remove {
            self.flag = ItemOrderStatus.update
        }
        self.updateQuantityView(quantity: newQuantity, flag: flag)
    }
    
    func decreaseQuantity(quantity: Int) {
        var newQuantity = quantity
        if self.flag == ItemOrderStatus.create && quantity > 1 {
            newQuantity = quantity - 1
        } else if self.flag == ItemOrderStatus.update && quantity > 0 {
            newQuantity = quantity - 1
            if newQuantity == 0 {
                self.flag = ItemOrderStatus.remove
            }
        }
        self.updateQuantityView(quantity: newQuantity, flag: flag)
    }
    
    
    private func fetchOrder() {
        self.orderViewModel.fetch { orderViewModel in
            if let orderVM = orderViewModel {
                self.orderViewModel = orderVM
            }
        }
    }
    
    private func fetchItems() {
        if orderViewModel.order != nil {
            self.itemOrderListViewModel.fetchAll(orderViewModel: self.orderViewModel) { itemOrderListVM in
                if let itemOrderListVM = itemOrderListVM {
                    self.itemOrderListViewModel = itemOrderListVM
                }
            }
        }
    }
    
    private func fetchCurrentItem() {
        if orderViewModel.order != nil {
            self.itemOrderViewModel.fetchItem(itemMenuViewModel:  self.itemMenuViewModel, orderViewModel: self.orderViewModel) { itemOrderVM in
                if let itemOrderVM = itemOrderVM {
                    self.itemOrderViewModel = itemOrderVM
                    self.setFlag()
                }
            }
        }
    }
    
    func addToCart(isRemoveItem: Bool, quantity: Int, comment: String) {
        let name = self.itemMenuViewModel?.itemMenu.name
        let itemId = self.itemMenuViewModel?.itemMenu.itemId
        let price = self.itemMenuViewModel?.itemMenu.price
      
        self.itemOrderViewModel.name = name!
        self.itemOrderViewModel.itemId = Int64(itemId!)
        self.itemOrderViewModel.price = price!
        self.itemOrderViewModel.quantity = Int64(quantity)
        self.itemOrderViewModel.comment = comment
        
        if isRemoveItem {
            self.itemOrderViewModel.removeItem(itemOrderViewModel: self.itemOrderViewModel, orderViewModel: self.orderViewModel, completion: { success in
                if success {
                    self.delegate?.didGoToHomeScreen()
                }
            })
        } else {
            self.itemOrderViewModel.saveItem(itemOrderViewModel: self.itemOrderViewModel, orderViewModel: self.orderViewModel, completion: { success in
                if success {
                    self.delegate?.didGoToCartScreen()
                }
            })
        }
    }
    
    private func setFlag() {
        self.flag = self.itemOrderViewModel.getFlag()
    }
}
