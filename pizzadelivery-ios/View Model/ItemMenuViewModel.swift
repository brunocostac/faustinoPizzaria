//
//  ItemMenuViewModl.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 27/01/22.
//

import Foundation

struct ItemMenuViewModel {
    let itemMenu: ItemMenu
}

extension ItemMenuViewModel {
    init(_ itemMenu: ItemMenu) {
        self.itemMenu = itemMenu
    }
}
