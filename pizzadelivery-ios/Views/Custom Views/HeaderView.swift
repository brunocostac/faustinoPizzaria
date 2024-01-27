//
//  TableHeaderView.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 07/01/22.
//

import UIKit

class HeaderView: UIView {
    
    let nameLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 26)!, textColor: .black, numberOfLines: 0)
    let addressLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 14)!, textColor: .systemGray, numberOfLines: 0)
    let timeLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 14)!, textColor: .green, numberOfLines: 0)
    let feeLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 14)!, textColor: .gray, numberOfLines: 0)
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setup()
        self.setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    // MARK: - Functions
    
    func setup() {
        self.nameLabel.text = "Faustino - Freguesia"
        self.addressLabel.text = "Rua Araguaia 2000"
        self.timeLabel.text = "⏱ Aberto"
        self.feeLabel.text = "Entrega a partir de R$ 0,00 ● 45m - 1h"
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 60)
    }
    
    // MARK: - Setup Constraints
    
    private func setupNameLabelConstraints() {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            self.nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
    
    private func setupAddressLabelConstraints() {
        self.addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.addressLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 6),
            self.addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
    
    private func setupTimeLabelConstraints() {
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.timeLabel.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor, constant: 6),
            self.timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
    
    private func setupFeeLabelConstraints() {
        self.feeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.feeLabel.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 6),
            self.feeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
}

extension HeaderView: ViewConfiguration {
    func setupConstraints() {
        self.setupNameLabelConstraints()
        self.setupAddressLabelConstraints()
        self.setupTimeLabelConstraints()
        self.setupFeeLabelConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(self.nameLabel)
        addSubview(self.addressLabel)
        addSubview(self.timeLabel)
        addSubview(self.feeLabel)
    }
    
    func configureViews() {
        backgroundColor = .white
    }
}
