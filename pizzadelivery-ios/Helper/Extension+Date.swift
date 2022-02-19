//
//  Extension+Date.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 16/02/22.
//

import Foundation

extension Date {    
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
