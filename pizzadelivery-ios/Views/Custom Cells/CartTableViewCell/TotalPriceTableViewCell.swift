//
//  TotalPriceTableViewCell.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 13/01/22.
//

import UIKit

class TotalPriceTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    let subTotalLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 16)!, textColor: .black, numberOfLines: 0)
    let feeLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 16)!, textColor: .black, numberOfLines: 0)
    let totalLabel: UILabel = MyLabel(font: UIFont(name: "avenir-heavy", size: 16)!, textColor: .black, numberOfLines: 0)
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithText(subTotalOrder: String, totalOrder: String, fee: String) {
        subTotalLabel.text = "Subtotal: R$ \(subTotalOrder)"
        totalLabel.text = "Total: R$ \(totalOrder)"
        feeLabel.text = "Taxa de entrega: \(fee)"
    }
    
    // MARK: - Setup Constraints
    private func setupSubTotalLabelConstraints() {
        subTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTotalLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            subTotalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    func setupDeliveryFeeLabelConstraints() {
        feeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feeLabel.topAnchor.constraint(equalTo: subTotalLabel.bottomAnchor, constant: 10),
            feeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    func setupTotalLabelConstraints() {
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: feeLabel.bottomAnchor, constant: 10),
            totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            totalLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

extension TotalPriceTableViewCell: ViewConfiguration {
    func setupConstraints() {
        setupSubTotalLabelConstraints()
        setupDeliveryFeeLabelConstraints()
        setupTotalLabelConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(subTotalLabel)
        addSubview(feeLabel)
        addSubview(totalLabel)
    }
    
    func configureViews() {
        backgroundColor = .white
        selectionStyle = .none
    }
}
