//
//  PaymentViewModel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 21/03/23.
//

import Foundation


protocol PaymentViewModelDelegate: AnyObject {
    func didDisplayAlert(title: String, message: String, actionClosure: @escaping () -> Void)
    func didGoToMenuScreen()
}

class PaymentViewModel {
    var orderViewModel = OrderViewModel()
    var itemOrderListViewModel = ItemOrderListViewModel()
    
    var section: [String] = ["Forma de pagamento na entrega", "Resumo do Pedido", "Entregar em"]
    
    weak var delegate: PaymentViewModelDelegate?
    
    func viewDidAppear() {
        self.fetchOrder()
        self.fetchItems()
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
    
   func sendOrder(paymentSelected: String) {
        if self.orderViewModel.isValidAddress() {
            if !(itemOrderListViewModel.itemOrderViewModel?.isEmpty ?? true) {
                let itemListOrderVM = itemOrderListViewModel
                self.orderViewModel.order?.total = Double(itemListOrderVM.totalItemOrder)!
                self.orderViewModel.order?.dateWasRequest = Date()
                self.orderViewModel.order?.dateCompletion = Date(timeInterval: 60*5, since: Date())
                self.orderViewModel.order?.subTotal = Double(itemListOrderVM.totalItemOrder)!
                self.orderViewModel.order?.isOpen = false
                self.orderViewModel.order?.paymentMethod = paymentSelected
            }
            MockApiClient().sendOrder { [self] response in
                if response {
                    self.saveOrder()
                }
            }
        } else {
            self.delegate?.didDisplayAlert(title: "Informação", message: "Por favor, informe o endereço de entrega.", actionClosure: {
            })
        }
    }
    
    
    private func saveOrder() {
        self.orderViewModel.saveOrder(orderViewModel: orderViewModel) { success in
            if success {
                self.delegate?.didDisplayAlert(title: "Sucesso", message: "Pedido recebido, já começaremos a preparar", actionClosure: { [self] in
                    self.delegate?.didGoToMenuScreen()
                })
            } else {
                self.delegate?.didDisplayAlert(title: "Erro", message: "Não foi possível realizar o pedido, tente novamente mais tarde!", actionClosure: { [self] in
                    self.delegate?.didGoToMenuScreen()
                })
            }
        }
    }
}
