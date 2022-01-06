//
//  MenuBaseCoordinated.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import Foundation

protocol MenuBaseCoordinated {
    var coordinator: MenuBaseCoordinator? { get }
    init(coordinator: MenuBaseCoordinator)
}
