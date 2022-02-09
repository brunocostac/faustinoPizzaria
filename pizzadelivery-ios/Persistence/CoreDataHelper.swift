//
//  CoreDataHelper.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 02/02/22.
//

import Foundation
import CoreData

class CoreDataHelper {
    private let coreDataStack = CoreDataStack.shared
    
    // MARK: - Order functions
    
    public func createOrder() {
        let orderEntity = Order(context: self.coreDataStack.managedObjectContext)
        
        orderEntity.isOpen = true
        orderEntity.orderId = UUID()
        coreDataStack.saveContext()
    }
    
    public func fetchCurrentOrder() -> [Order]? {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        let predicate = NSPredicate(format: "isOpen == true")
        var order: [Order]? = []
        
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            order = try self.coreDataStack.managedObjectContext.fetch(request)
            return order
        } catch {
            print("Error fetching data from context \(error)")
        }
        return order
    }
    
    // MARK: - ItemOrder functions
    
    public func saveItem(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?) {
        let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
        
        if let currentItemId = itemOrderViewModel?.itemId, let currentOrder = orderViewModel?.order {
            
            let itemIdAsString = String(describing: currentItemId)
            let predicateOne = NSPredicate(format: "itemId MATCHES %@", itemIdAsString)
            let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
            
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
            
            do {
                let result = try coreDataStack.managedObjectContext.fetch(request)
                if result == [] {
                    createItem(itemOrderViewModel: itemOrderViewModel, orderViewModel: orderViewModel)
                } else {
                    updateItem(itemOrderViewModel: itemOrderViewModel, orderViewModel: orderViewModel)
                }
            } catch {
                print("Error fetching data from context \(error)")
            }
            
        }
    }
    
    public func updateItem(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?) {
        let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
        
        if let currentItemId = itemOrderViewModel?.itemId, let currentOrder = orderViewModel?.order {
            
            let itemIdAsString = String(describing: currentItemId)
            let predicateOne = NSPredicate(format: "(itemId MATCHES %@)", itemIdAsString)
            let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
            
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
            
            do {
                let currentItem = try coreDataStack.managedObjectContext.fetch(request)
                currentItem.first!.setValue(itemOrderViewModel!.price, forKey: "price")
                currentItem.first!.setValue(itemOrderViewModel!.quantity, forKey: "quantity")
                currentItem.first!.setValue(itemOrderViewModel!.name, forKey: "name")
                currentItem.first!.setValue(itemOrderViewModel!.comment, forKey: "comment")
                
                coreDataStack.saveContext()
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    }
    
    public func createItem(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?) {
        let itemEntity = ItemOrder(context: coreDataStack.managedObjectContext)
        
        itemEntity.name = itemOrderViewModel!.name
        itemEntity.price = itemOrderViewModel!.price
        itemEntity.itemId = itemOrderViewModel!.itemId
        itemEntity.comment = itemOrderViewModel!.comment
        itemEntity.quantity = itemOrderViewModel!.quantity
        itemEntity.parentOrder = orderViewModel?.order
        
        coreDataStack.saveContext()
    }
    
    public func removeItem(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?) {
        let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
        
        if let currentItemId = itemOrderViewModel?.itemId, let currentOrder = orderViewModel?.order {
            
            let itemIdAsString = String(describing: currentItemId)
            let predicateOne = NSPredicate(format: "(itemId MATCHES %@)", itemIdAsString)
            let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
            
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
            
            do {
                let currentItem = try coreDataStack.managedObjectContext.fetch(request)
                coreDataStack.managedObjectContext.delete(currentItem[0])
                coreDataStack.saveContext()
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    }
    
    public func fetchCurrentItem(itemMenuViewModel: ItemMenuViewModel?, orderViewModel: OrderViewModel?, completion: @escaping ([ItemOrderViewModel]) -> Void) {
        let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
        let currentItemId = String(describing: itemMenuViewModel!.itemMenu.itemId)
        let currentOrder =  orderViewModel!.order
        let predicateOne = NSPredicate(format: "(itemId MATCHES %@)", currentItemId)
        let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
        var itemOrderArray = [ItemOrderViewModel]()
        
        do {
            let itemOrders: [ItemOrder] = try coreDataStack.managedObjectContext.fetch(request)
            if itemOrders != [] {
                for itemOrder in itemOrders {
                    let viewModel = ItemOrderViewModel(itemOrder: itemOrder)
                    itemOrderArray.append(viewModel)
                    completion(itemOrderArray)
                }
            } else {
                completion([])
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}
