//
//  OrderBaseCoordinated.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import Foundation

protocol OrderBaseCoordinated {
    var coordinator: OrderBaseCoordinator? { get }
    init(coordinator: OrderBaseCoordinator)
}
