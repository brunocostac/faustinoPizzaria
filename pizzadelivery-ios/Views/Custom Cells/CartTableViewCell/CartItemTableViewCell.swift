//
//  CartItemTableViewCell.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 13/01/22.
//

import UIKit

class CartItemTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    let itemNameLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 14)!, textColor: .black, numberOfLines: 0)
    let itemTotalLabel: UILabel = MyLabel(font: UIFont(name: "avenir-heavy", size: 16)!, textColor: .black, numberOfLines: 0)

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithText(itemDescription: String, itemTotal: String) {
        itemNameLabel.text = itemDescription
        itemTotalLabel.text = itemTotal
    }
    
    private func setupItemLabelConstraints() {
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            itemNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            itemNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func setupItemTotalLabelConstraints() {
        itemTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemTotalLabel.firstBaselineAnchor.constraint(equalTo: itemNameLabel.firstBaselineAnchor),
            itemTotalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}

extension CartItemTableViewCell: ViewConfiguration {
    func setupConstraints() {
        setupItemLabelConstraints()
        setupItemTotalLabelConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(itemNameLabel)
        addSubview(itemTotalLabel)
    }
    
    func configureViews() {
        backgroundColor = .white
        selectionStyle = .none
    }
}
