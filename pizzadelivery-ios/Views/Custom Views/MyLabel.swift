//
//  MyLabel.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 07/01/22.
//

import UIKit

class MyLabel: UILabel {
    init(text: String = "", font: UIFont, textColor: UIColor, numberOfLines: Int) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
