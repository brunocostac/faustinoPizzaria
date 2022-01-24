//
//  Menu.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 18/01/22.
//

import UIKit

struct Menu: Decodable {
    let category: String
    let items: [ItemMenu]
    
    init(category: String, items: [ItemMenu]) {
        self.category = category
        self.items = items
    }
}
