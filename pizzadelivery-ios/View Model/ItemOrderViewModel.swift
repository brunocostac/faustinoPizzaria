//
//  ItemOrderViewModel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 27/01/22.
//

import Foundation
import CoreData

class ItemOrderListViewModel {
    var itemOrderViewModel: [ItemOrderViewModel]?
    private let coreDataStack = CoreDataStack.shared
    
    init(itemsOrder: [ItemOrderViewModel]? = []) {
        self.itemOrderViewModel = itemsOrder
    }
}

extension ItemOrderListViewModel {
    func fetchAll(orderViewModel: OrderViewModel?) {
        let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
        var itemsVM = [ItemOrderViewModel]()
        
        if let currentOrder = orderViewModel?.order {
            let predicate = NSPredicate(format: "parentOrder == %@", currentOrder)
            request.predicate = predicate
           
            do {
                let itemOrders: [ItemOrder] = try self.coreDataStack.managedObjectContext.fetch(request)
                if itemOrders != [] {
                    for itemOrder in itemOrders {
                        let viewModel = ItemOrderViewModel(itemOrder)
                        itemsVM.append(viewModel)
                    }
                }
                self.itemOrderViewModel = itemsVM
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    }
    
    func itemOrderAtIndex(_ index: Int) -> ItemOrderViewModel? {
        return self.itemOrderViewModel?[index] ?? nil
    }
    
    var totalOrder: String {
        var total: Double = 0.0
        if let itemOrder = itemOrderViewModel {
            for item in itemOrder {
                total += Double(item.itemOrder?.quantity ?? 0) * (item.itemOrder?.price ?? 0.00)
            }
        }
        return String(format: "%.2f", total)
    }
    
    var quantity: String {
        var total: Int = 0
        if let itemOrderVM = itemOrderViewModel {
            for item in itemOrderVM {
                total += Int(item.itemOrder?.quantity ?? 0)
            }
        }
        return String(describing: total)
    }
    
    var itemsDescription: String {
        var items = ""
        if let itemOrderVM = itemOrderViewModel {
            for item in itemOrderVM {
                if let quantity = item.itemOrder?.quantity, let name = item.itemOrder?.name {
                    items += "- \(String(describing: quantity)) \(String(describing: name)) "
                }
            }
        }
        return items
    }
    
    var count: Int {
        return self.itemOrderViewModel?.count ?? 0
    }
    
    var cartButtonIsEnabled: Bool {
        return !(self.itemOrderViewModel?.isEmpty ?? false)
    }
}

struct ItemOrderViewModel{
    var itemOrder: ItemOrder?
    private let coreDataStack = CoreDataStack.shared
}

extension ItemOrderViewModel {
    init(_ itemOrder: ItemOrder? = nil) {
        self.itemOrder = itemOrder
    }
}
extension ItemOrderViewModel {
    mutating func saveItem(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?, completion: @escaping (Bool) -> Void) {
       if let currentItemId = itemOrderViewModel?.itemOrder?.itemId, let currentOrder = orderViewModel?.order {
           let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
           let itemIdAsString = String(describing: currentItemId)
           let predicateOne = NSPredicate(format: "itemId MATCHES %@", itemIdAsString)
           let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
           
           request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
           
           do {
               let result = try coreDataStack.managedObjectContext.fetch(request)
               if result == [] {
                   self.createItem(itemOrderViewModel: itemOrderViewModel, orderViewModel: orderViewModel)
               } else {
                   self.updateItem(itemOrderViewModel: itemOrderViewModel, orderViewModel: orderViewModel)
               }
               completion(true)
           } catch {
               completion(false)
               print("Error fetching data from context \(error)")
           }
       } else {
           completion(false)
       }
   }
     mutating func createItem(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?) {
        let itemCd = ItemOrder(context: self.coreDataStack.managedObjectContext)
        itemCd.name = itemOrderViewModel!.itemOrder?.name
        itemCd.price = itemOrderViewModel!.itemOrder?.price ?? 0.00
        itemCd.itemId = itemOrderViewModel!.itemOrder?.itemId ?? 0
        itemCd.comment = itemOrderViewModel!.itemOrder?.comment ?? ""
        itemCd.quantity = itemOrderViewModel!.itemOrder?.quantity ?? 0
        itemCd.parentOrder = orderViewModel?.order
        
        self.itemOrder = itemCd as! ItemOrder
        self.coreDataStack.saveContext()
    }
    
    mutating func updateItem(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?) {
        if let currentItemId = itemOrderViewModel?.itemOrder?.itemId, let currentOrder = orderViewModel?.order {
            let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
            let itemIdAsString = String(describing: currentItemId)
            let predicateOne = NSPredicate(format: "(itemId MATCHES %@)", itemIdAsString)
            let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
            
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
            
            do {
                let itemCd = try coreDataStack.managedObjectContext.fetch(request)
                itemCd.first!.setValue(itemOrderViewModel!.itemOrder?.price, forKey: "price")
                itemCd.first!.setValue(itemOrderViewModel!.itemOrder?.quantity, forKey: "quantity")
                itemCd.first!.setValue(itemOrderViewModel!.itemOrder?.name, forKey: "name")
                itemCd.first!.setValue(itemOrderViewModel!.itemOrder?.comment, forKey: "comment")
                
                self.itemOrder = itemCd.first! as! ItemOrder
                self.coreDataStack.saveContext()
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    }
    
    public mutating func removeItem(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?, completion: @escaping (Bool) -> Void) {
        if let currentItemId = itemOrderViewModel?.itemOrder?.itemId, let currentOrder = orderViewModel?.order {
            let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
            let itemIdAsString = String(describing: currentItemId)
            let predicateOne = NSPredicate(format: "(itemId MATCHES %@)", itemIdAsString)
            let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
            
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
            
            do {
                let currentItem = try coreDataStack.managedObjectContext.fetch(request)
                self.coreDataStack.managedObjectContext.delete(currentItem[0])
                self.coreDataStack.saveContext()
                self.itemOrder = nil
                completion(true)
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    }
    
    public mutating func fetchItem(itemMenuViewModel: ItemMenuViewModel?, orderViewModel: OrderViewModel?) {
        let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
        let currentItemId = String(describing: itemMenuViewModel!.itemMenu.itemId)
       
        if let currentOrder = orderViewModel?.order {
            let predicateOne = NSPredicate(format: "(itemId MATCHES %@)", currentItemId)
            let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
            
            do {
                let currentItem = try self.coreDataStack.managedObjectContext.fetch(request)
                itemOrder = currentItem.first
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    }
    
    func calculateTotal(_ quantity: Int, price: Double) -> String {
        let total = Double(quantity) * Double(price)
        return String(format: "%.2f", total)
    }
    
    var itemDescription: String {
        if let quantity = self.itemOrder?.quantity, let name = self.itemOrder?.name {
            return "\(String(describing: quantity)) \(String(describing: name))"
        }
        return ""
    }
    var itemTotal: String {
        if let price = self.itemOrder?.price {
          return "R$ \(String(describing: price))"
        }
        return ""
    }
}
 
