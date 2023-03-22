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
    func fetchAll(orderViewModel: OrderViewModel?, completion: @escaping (ItemOrderListViewModel?) -> Void) {
        let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
        var itemOrderListVM: ItemOrderListViewModel?
        
        if let currentOrder = orderViewModel?.order {
            let predicate = NSPredicate(format: "parentOrder == %@", currentOrder)
            var itemsVM = [ItemOrderViewModel]()
            
            request.predicate = predicate
            
            do {
                let itemOrders: [ItemOrder] = try self.coreDataStack.managedObjectContext.fetch(request)
                if itemOrders != [] {
                    for itemOrder in itemOrders {
                        let viewModel = ItemOrderViewModel(itemOrder: itemOrder)
                        itemsVM.append(viewModel)
                    }
                    itemOrderListVM = ItemOrderListViewModel(itemsOrder: itemsVM)
                    completion(itemOrderListVM)
                }
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
        completion(itemOrderListVM)
    }
    
    func itemOrderAtIndex(_ index: Int) -> ItemOrderViewModel? {
        return self.itemOrderViewModel?[index] ?? nil
    }
    
    var totalItemOrder: String {
        var total: Double = 0.0
        if let itemOrder = itemOrderViewModel {
            for item in itemOrder {
                total += Double(item.quantity ?? 0) * (item.price ?? 0.00)
            }
        }
        return String(format: "%.2f", total)
    }
    
    var quantity: String {
        var total: Int = 0
        if let itemOrderVM = itemOrderViewModel {
            for item in itemOrderVM {
                total += Int(item.quantity!)
            }
        }
        return String(describing: total)
    }
    
    var itemsDescription: String {
        var items = ""
        if let itemOrderVM = itemOrderViewModel {
            for item in itemOrderVM {
                items += "- \(item.quantity!) \(item.name!) "
            }
        }
        return items
    }
    
    var count: Int {
        return self.itemOrderViewModel?.count ?? 0
    }
    
    var cartButtonIsEnabled: Bool {
        return self.itemOrderViewModel?.count != 0 ? true : false
    }
}

struct ItemOrderViewModel{
    var name: String?
    var itemId: Int64?
    var price: Double?
    var quantity: Int64?
    var comment: String?
    private let coreDataStack = CoreDataStack.shared
    
    init(itemOrder: ItemOrder? = nil) {
        self.name = itemOrder?.name! ?? nil
        self.itemId = itemOrder?.itemId ?? nil
        self.price = itemOrder?.price ?? nil
        self.quantity = itemOrder?.quantity ?? nil
        self.comment = itemOrder?.comment ?? nil
    }
    
    init(name: String, itemId: Int64, price: Double, quantity: Int64, comment: String) {
        self.name = name
        self.itemId = itemId
        self.price = price
        self.quantity = quantity
        self.comment = comment
    }
}

extension ItemOrderViewModel {
    mutating func saveItem(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?, completion: @escaping (Bool) -> Void) {
       if let currentItemId = itemOrderViewModel?.itemId, let currentOrder = orderViewModel?.order {
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
        itemCd.name = itemOrderViewModel?.name
        itemCd.price = itemOrderViewModel?.price ?? 0.00
        itemCd.itemId = itemOrderViewModel?.itemId ?? 0
        itemCd.comment = itemOrderViewModel?.comment ?? ""
        itemCd.quantity = itemOrderViewModel?.quantity ?? 0
        itemCd.parentOrder = orderViewModel?.order
        
        self.coreDataStack.saveContext()
    }
    
    mutating func updateItem(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?) {
        if let currentItemId = itemOrderViewModel?.itemId, let currentOrder = orderViewModel?.order {
            let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
            let itemIdAsString = String(describing: currentItemId)
            let predicateOne = NSPredicate(format: "(itemId MATCHES %@)", itemIdAsString)
            let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
            
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
            
            do {
                let itemCd = try coreDataStack.managedObjectContext.fetch(request)
                itemCd.first!.setValue(itemOrderViewModel!.price, forKey: "price")
                itemCd.first!.setValue(itemOrderViewModel!.quantity, forKey: "quantity")
                itemCd.first!.setValue(itemOrderViewModel!.name, forKey: "name")
                itemCd.first!.setValue(itemOrderViewModel!.comment, forKey: "comment")
                
                self.coreDataStack.saveContext()
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    }
    
    public func removeItem(itemOrderViewModel: ItemOrderViewModel?, orderViewModel: OrderViewModel?, completion: @escaping (Bool) -> Void) {
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
    
    public func fetchItem(itemMenuViewModel: ItemMenuViewModel?, orderViewModel: OrderViewModel?, completion: @escaping (ItemOrderViewModel?) -> Void) {
        let request: NSFetchRequest<ItemOrder> = ItemOrder.fetchRequest()
        let currentItemId = String(describing: itemMenuViewModel!.itemMenu.itemId)
        var itemOrderVM: ItemOrderViewModel?
        
        if let currentOrder = orderViewModel?.order {
            let predicateOne = NSPredicate(format: "(itemId MATCHES %@)", currentItemId)
            let predicateTwo = NSPredicate(format: "parentOrder == %@", currentOrder)
            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOne, predicateTwo])
            
            do {
                let currentItem = try self.coreDataStack.managedObjectContext.fetch(request)
                if currentItem != [] {
                    itemOrderVM = ItemOrderViewModel(itemOrder: currentItem[0])
                    completion(itemOrderVM)
                }
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
        completion(itemOrderVM)
    }
    
    func calculateTotal(_ quantity: Int, price: Double) -> String {
        let total = Double(quantity) * Double(price)
        return String(format: "%.2f", total)
    }
    
    var itemDescription: String {
        return "\(String(describing: self.quantity!)) \(String(describing: self.name!))"
     }
    var itemTotal: String {
        return "R$ \(String(describing: self.price!))"
    }
    
    func getFlag() -> ItemOrderStatus {
        if self.quantity == nil {
            return ItemOrderStatus.create
        } else if Int64(self.quantity!) > 0 {
            return ItemOrderStatus.update
        } else {
            return ItemOrderStatus.remove
        }
    }
}
 
