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

    var numberOfSections: Int {
        return menuViewModel.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.menuViewModel[section].items.count
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
    
    func itemMenuAtIndex(_ index: Int) -> ItemMenuViewModel {
        let itemMenu = self.menu.items[index]
        return ItemMenuViewModel(itemMenu: itemMenu)
    }
}
