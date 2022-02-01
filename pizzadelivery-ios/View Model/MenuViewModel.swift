//
//  MenuViewModel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 27/01/22.
//

import Foundation

class MenuListViewModel {
    var menuViewModel: [MenuViewModel]
    
    init() {
        self.menuViewModel = [MenuViewModel]()
    }
}

extension MenuListViewModel {
    func menuViewModel(at section: Int) -> MenuViewModel {
        return menuViewModel[section]
    }
}

struct MenuViewModel {
    let menu: Menu
}

extension MenuViewModel {
    var category: String {
        return self.menu.category
    }
    
    var items: [ItemMenu] {
        return self.menu.items
    }
}
