//
//  TableHeaderView.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 07/01/22.
//

import UIKit

class TableHeaderView: UIView {
    
    let nameLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 26)!, textColor: .black, numberOfLines: 0)
    
    let addressLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 14)!, textColor: .systemGray, numberOfLines: 0)
    
    let timeLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 14)!, textColor: .red, numberOfLines: 0)
    
    let feeLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 14)!, textColor: .gray, numberOfLines: 0)
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    // MARK: - Functions
    
    func setup() {
        nameLabel.text = "Pizza Lover - Freguesia"
        addressLabel.text = "Rua Araguaia 2000"
        timeLabel.text = "⏱ Abre 18:00"
        feeLabel.text = "Entrega a partir de R$ 4,00 ● 45m - 1h"
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 60)
    }
    
    // MARK: - Setup Constraints
    
    private func setupNameLabelConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
    
    private func setupAddressLabelConstraints() {
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
    
    private func setupTimeLabelConstraints() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 6),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
    
    private func setupFeeLabelConstraints() {
        feeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            feeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 6),
            feeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
}

extension TableHeaderView: ViewConfiguration {
    func setupConstraints() {
        setupNameLabelConstraints()
        setupAddressLabelConstraints()
        setupTimeLabelConstraints()
        setupFeeLabelConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(timeLabel)
        addSubview(feeLabel)
    }
    
    func configureViews() {
        backgroundColor = .red
    }
}
