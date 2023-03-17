//
//  OrderViewModel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 27/01/22.
//

import Foundation
import CoreData

class OrderListViewModel {
    var orderViewModel: [OrderViewModel]?
    private let coreDataStack = CoreDataStack.shared
    
    init(orders: [OrderViewModel]? = []) {
        self.orderViewModel = orders
    }
}

extension OrderListViewModel {
    func orderAtIndex(_ index: Int) -> OrderViewModel? {
        return self.orderViewModel?[index] ?? nil
    }
}

extension OrderListViewModel {
    public func fetchAll(completion: @escaping ([OrderViewModel]?) -> Void) {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        let predicate = NSPredicate(format: "isOpen == false")
        var orderVM = [OrderViewModel]()
        
        request.predicate = predicate
        
        do {
            let orders: [Order] = try coreDataStack.managedObjectContext.fetch(request)
            
            for order in orders {
                let viewModel = OrderViewModel(order: order)
                orderVM.append(viewModel)
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
        completion(orderVM)
    }
    
    var numberOfSections: Int {
        if self.orderViewModel?.count == 0 {
            return 0
        } else {
            return 1
        }
    }
    var numberOfRowsInSection: Int {
        return self.orderViewModel?.count ?? 0
    }
}

struct OrderViewModel {
    var order: Order?
    private let coreDataStack = CoreDataStack.shared
}

extension OrderViewModel {
    init(_ order: Order? = nil) {
        self.order = order
    }
}

extension OrderViewModel {
    public func createOrder() {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        let predicate = NSPredicate(format: "isOpen == true")
        let orderCD = Order(context: self.coreDataStack.managedObjectContext)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let orders: [Order] = try self.coreDataStack.managedObjectContext.fetch(request)
            if orders == [] {
                orderCD.isOpen = true
                orderCD.orderId = UUID()
                self.coreDataStack.saveContext()
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    public func fetch(completion: @escaping (OrderViewModel?) -> Void) {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        let predicate = NSPredicate(format: "isOpen == true")
        var order: Order?
        var orderVM: OrderViewModel?
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let orders: [Order] = try self.coreDataStack.managedObjectContext.fetch(request)
            if orders != [] {
                order = orders[0]
                orderVM = OrderViewModel(order: order!)
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
        completion(orderVM)
    }
    
    public func saveOrder(orderViewModel: OrderViewModel?,completion: @escaping (Bool) -> Void)  {
        if orderViewModel?.order != nil {
            let request: NSFetchRequest<Order> = Order.fetchRequest()
            request.fetchLimit = 1
            do {
                let result = try self.coreDataStack.managedObjectContext.fetch(request)
                if result != [] {
                    self.coreDataStack.saveContext()
                    completion(true)
                } else {
                    completion(false)
                }
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    }

    var dateRequest: String {
        if let dateWasRequest = self.order?.dateWasRequest {
            return "\(String(describing: dateWasRequest.getFormattedDate(format: "dd/MM/yyyy HH:mm")))"
        }
        return ""
    }
    
    var dateCompletion: String {
        if let dateCompletion = self.order?.dateCompletion {
            return "\(String(describing: dateCompletion.getFormattedDate(format: "dd/MM/yyyy HH:mm")))"
        }
        return ""
    }
    
    func isValidAddress() -> Bool {
        if self.order?.address != "" &&  self.order?.neighborhood != "" && self.order?.customerName != "" {
            return true
        } else {
            return false
        }
    }
    
    func getAddressMessage() -> String {
        let address = self.order?.address != "" ? self.order?.address : "Não existe endereço cadastrado"
        return address!
    }
}
