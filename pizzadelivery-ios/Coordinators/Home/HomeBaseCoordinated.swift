//
//  MenuBaseCoordinated.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import Foundation

protocol HomeBaseCoordinated {
    var coordinator: HomeBaseCoordinator? { get }
    init(coordinator: HomeBaseCoordinator)
}
