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
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithText(subTotalOrder: String, totalOrder: String, fee: String) {
        self.subTotalLabel.text = "Subtotal: R$ \(subTotalOrder)"
        self.totalLabel.text = "Total: R$ \(totalOrder)"
        self.feeLabel.text = "Taxa de entrega: \(fee)"
    }
    
    // MARK: - Setup Constraints
    private func setupSubTotalLabelConstraints() {
        self.subTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.subTotalLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            self.subTotalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    func setupDeliveryFeeLabelConstraints() {
        self.feeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.feeLabel.topAnchor.constraint(equalTo: self.subTotalLabel.bottomAnchor, constant: 10),
            self.feeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    func setupTotalLabelConstraints() {
        self.totalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.totalLabel.topAnchor.constraint(equalTo: self.feeLabel.bottomAnchor, constant: 10),
            self.totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            self.totalLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

extension TotalPriceTableViewCell: ViewConfiguration {
    func setupConstraints() {
        self.setupSubTotalLabelConstraints()
        self.setupDeliveryFeeLabelConstraints()
        self.setupTotalLabelConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(self.subTotalLabel)
        addSubview(self.feeLabel)
        addSubview(self.totalLabel)
    }
    
    func configureViews() {
        backgroundColor = .white
        selectionStyle = .none
    }
}
