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
    
    let subTotalValueLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 16)!, textColor: .black, numberOfLines: 1)
    
    let feeLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 16)!, textColor: .black, numberOfLines: 0)
    
    let feeValueLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 16)!, textColor: .systemGreen, numberOfLines: 0)

    let totalLabel: UILabel = MyLabel(font: UIFont(name: "avenir-heavy", size: 16)!, textColor: .black, numberOfLines: 0)
    
    let totalValueLabel: UILabel = MyLabel(font: UIFont(name: "avenir-heavy", size: 18)!, textColor: .black, numberOfLines: 0)

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Constraints
    private func setupSubTotalLabelConstraints() {
        subTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTotalLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            subTotalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    private func setupSubTotalValueLabelConstraints() {
        subTotalValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTotalValueLabel.firstBaselineAnchor.constraint(equalTo: subTotalLabel.firstBaselineAnchor),
            subTotalValueLabel.leadingAnchor.constraint(equalTo: subTotalLabel.trailingAnchor, constant: 10)
        ])
    }
    
    func setupDeliveryFeeLabelConstraints() {
        feeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feeLabel.topAnchor.constraint(equalTo: subTotalLabel.bottomAnchor, constant: 10),
            feeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    func setupDeliveryFeeValueLabelConstraints() {
        feeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feeValueLabel.firstBaselineAnchor.constraint(equalTo: feeLabel.firstBaselineAnchor),      feeValueLabel.leadingAnchor.constraint(equalTo: feeLabel.trailingAnchor, constant: 10)
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
    
    func setupTotalValueLabelConstraints() {
        totalValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalValueLabel.firstBaselineAnchor.constraint(equalTo: totalLabel.firstBaselineAnchor),
            totalValueLabel.leadingAnchor.constraint(equalTo: totalLabel.trailingAnchor, constant: 10)
        ])
    }
}

extension TotalPriceTableViewCell: ViewConfiguration {
    func setupConstraints() {
        setupSubTotalLabelConstraints()
        setupSubTotalValueLabelConstraints()
        setupDeliveryFeeLabelConstraints()
        setupDeliveryFeeValueLabelConstraints()
        setupTotalLabelConstraints()
        setupTotalValueLabelConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(subTotalLabel)
        addSubview(subTotalValueLabel)
        addSubview(feeLabel)
        addSubview(feeValueLabel)
        addSubview(totalLabel)
        addSubview(totalValueLabel)
    }
    
    func configureViews() {
        backgroundColor = .white
        selectionStyle = .none
    }
}
