//
//  DeliveryLocationViewModel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 21/03/23.
//

import Foundation

protocol DeliveryLocationViewModelDelegate: AnyObject {
    func didPopulateTextFields(address: String, neighborhood: String, customerName: String)
    func didDisplayAlert()
    func didGoToPreviousScreen()
}


class DeliveryLocationViewModel {
    
    var orderViewModel = OrderViewModel()
    
    var delegate: DeliveryLocationViewModelDelegate?
    
    func viewDidAppear() {
        self.fetchOrder()
        self.populateTextFields()
    }
    
    
    private func fetchOrder() {
        self.orderViewModel.fetch { orderViewModel in
            if let orderVM = orderViewModel {
                self.orderViewModel = orderVM
            }
        }
    }
    
    private func populateTextFields() {
        if let orderVM = orderViewModel.order {
            self.delegate?.didPopulateTextFields(address:  orderVM.address ?? "", neighborhood:  orderVM.neighborhood ?? "", customerName:  orderVM.customerName ?? "")
        }
    }
    
    
    func saveOrder(address: String, neighborhood: String, customerName: String) {
        self.orderViewModel.order?.address = address
        self.orderViewModel.order?.neighborhood = neighborhood
        self.orderViewModel.order?.customerName = customerName
        
        if self.orderViewModel.isValidAddress() {
            self.orderViewModel.saveOrder(orderViewModel: orderViewModel) { success in
                if success {
                    self.delegate?.didGoToPreviousScreen()
                }
            }
        } else {
            self.delegate?.didDisplayAlert()
        }
    }
}
