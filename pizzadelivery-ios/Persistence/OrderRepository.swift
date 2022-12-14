//
//  OrderRepository.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 14/12/22.
//

import Foundation
import CoreData

class OrderRepository {
    
    private let coreDataStack = CoreDataStack.shared
    
    public func create() {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        let predicate = NSPredicate(format: "isOpen == true")
        let orderEntity = Order(context: self.coreDataStack.managedObjectContext)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let orders: [Order] = try self.coreDataStack.managedObjectContext.fetch(request)
            if orders == [] {
                orderEntity.isOpen = true
                orderEntity.orderId = UUID()
                self.coreDataStack.saveContext()
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    
    public func fetch(completion: @escaping (Order?) -> Void) {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        let predicate = NSPredicate(format: "isOpen == true")
        var order: Order?
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let orders: [Order] = try self.coreDataStack.managedObjectContext.fetch(request)
            if orders != [] {
                order = orders[0]
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
        completion(order)
    }
    
    public func update(orderViewModel: OrderViewModel?, completion: @escaping (Bool) -> Void) {
        if orderViewModel != nil {
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
}
