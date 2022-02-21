//
//  ItemMenuViewModl.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 27/01/22.
//

import Foundation
import UIKit

struct ItemMenuViewModel {
    let itemMenu: ItemMenu
}

extension ItemMenuViewModel {
    init(_ itemMenu: ItemMenu) {
        self.itemMenu = itemMenu
    }
}

extension ItemMenuViewModel {
    var name: String {
        return self.itemMenu.name
    }
    
    var description: String {
        return self.itemMenu.description
    }
    
    var image: UIImage {
        return UIImage(named: self.itemMenu.imageUrl)!
    }
    
    var price: String {
        return "R$ \(self.itemMenu.price)"
    }
}
