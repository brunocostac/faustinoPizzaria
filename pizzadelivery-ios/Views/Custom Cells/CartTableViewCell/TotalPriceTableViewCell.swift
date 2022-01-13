//
//  TotalPriceTableViewCell.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 13/01/22.
//

import UIKit

class TotalPriceTableViewCell: UITableViewCell {

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TotalPriceTableViewCell: ViewConfiguration {
    func setupConstraints() {
        
    }
    
    func buildViewHierarchy() {
        
    }
    
    func configureViews() {
        
    }
}
