//
//  ItemOrderRepository.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 14/12/22.
//

import Foundation
import CoreData


class ItemOrderRepository {
    
    private let coreDataStack = CoreDataStack.shared
    
    public func save(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?, completion: @escaping (Bool) -> Void) {
        if let currentItemId = itemOrderViewModel?.itemId, let currentOrder = orderViewModel?.order {
            let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
            let itemIdAsString = String(describing: currentItemId)
            let predicateOne = NSPredicate(format: "itemId MATCHES %@", itemIdAsString)
            let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
            
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
            
            do {
                let result = try coreDataStack.managedObjectContext.fetch(request)
                if result == [] {
                    self.create(itemOrderViewModel: itemOrderViewModel, orderViewModel: orderViewModel)
                } else {
                    self.update(itemOrderViewModel: itemOrderViewModel, orderViewModel: orderViewModel)
                }
                completion(true)
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    }
    
    public func create(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?) {
        let itemEntity = ItemOrder(context: coreDataStack.managedObjectContext)
        itemEntity.name = itemOrderViewModel!.name
        itemEntity.price = itemOrderViewModel!.price
        itemEntity.itemId = itemOrderViewModel!.itemId
        itemEntity.comment = itemOrderViewModel!.comment
        itemEntity.quantity = itemOrderViewModel!.quantity
        itemEntity.parentOrder = orderViewModel?.order
        
        self.coreDataStack.saveContext()
    }
    
    public func update(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?) {
        if let currentItemId = itemOrderViewModel?.itemId, let currentOrder = orderViewModel?.order {
            let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
            let itemIdAsString = String(describing: currentItemId)
            let predicateOne = NSPredicate(format: "(itemId MATCHES %@)", itemIdAsString)
            let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
            
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
            
            do {
                let itemEntity = try coreDataStack.managedObjectContext.fetch(request)
                itemEntity.first!.setValue(itemOrderViewModel!.price, forKey: "price")
                itemEntity.first!.setValue(itemOrderViewModel!.quantity, forKey: "quantity")
                itemEntity.first!.setValue(itemOrderViewModel!.name, forKey: "name")
                itemEntity.first!.setValue(itemOrderViewModel!.comment, forKey: "comment")
                
                coreDataStack.saveContext()
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    }
    
    
    public func remove(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?, completion: @escaping (Bool) -> Void) {
        if let currentItemId = itemOrderViewModel?.itemId, let currentOrder = orderViewModel?.order {
            let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
            let itemIdAsString = String(describing: currentItemId)
            let predicateOne = NSPredicate(format: "(itemId MATCHES %@)", itemIdAsString)
            let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
            
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
            
            do {
                let currentItem = try coreDataStack.managedObjectContext.fetch(request)
                self.coreDataStack.managedObjectContext.delete(currentItem[0])
                self.coreDataStack.saveContext()
                completion(true)
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    }
    
    public func fetch(itemMenuViewModel: ItemMenuViewModel?, orderViewModel: OrderViewModel?) -> ItemOrderViewModel? {
        let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
        let currentItemId = String(describing: itemMenuViewModel!.itemMenu.itemId)
        var itemOrderVM: ItemOrderViewModel?
        
        if let currentOrder = orderViewModel?.order {
            let predicateOne = NSPredicate(format: "(itemId MATCHES %@)", currentItemId)
            let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
            
            do {
                let currentItem = try coreDataStack.managedObjectContext.fetch(request)
                if currentItem != [] {
                    itemOrderVM = ItemOrderViewModel(itemOrder: currentItem[0])
                }
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
        return itemOrderVM
    }
    
    public func fetchAll(orderViewModel: OrderViewModel?) -> ItemOrderListViewModel? {
        let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
        var itemOrderListVM: ItemOrderListViewModel?
        if let currentOrder = orderViewModel?.order {
            let predicate = NSPredicate(format: "parentOrder == %@", currentOrder)
            var itemsVM = [ItemOrderViewModel]()

            request.predicate = predicate
           
            do {
                let itemOrders: [ItemOrder] = try coreDataStack.managedObjectContext.fetch(request)
                if itemOrders != [] {
                    for itemOrder in itemOrders {
                        let viewModel = ItemOrderViewModel(itemOrder: itemOrder)
                        itemsVM.append(viewModel)
                    }
                    itemOrderListVM = ItemOrderListViewModel(itemsOrder: itemsVM)
                }
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
        return itemOrderListVM
    }
}
