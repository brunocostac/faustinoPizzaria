//
//  MyCartButton.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 12/01/22.
//
import UIKit

class MyCartButton: UIButton {
    
    // MARK: - Views
    
    private let myCartLabel: UILabel = {
        let myCartLabel = UILabel()
        myCartLabel.textColor = .white
        myCartLabel.text = "Meu carrinho"
        myCartLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        return myCartLabel
    }()
    
    private let itemLabel: UILabel = {
        let itemLabel = UILabel()
        itemLabel.textColor = .white
        itemLabel.text = "1 item"
        itemLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        return itemLabel
    }()
    
    private let totalPriceLabel: UILabel = {
        let totalPriceLabel = UILabel()
        totalPriceLabel.textColor = .white
        totalPriceLabel.text = "R$ 35,90"
        totalPriceLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
        return totalPriceLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    
    // MARK: - Setup Constraints
    
    func setupButtonConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupItemLabelConstraints() {
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            itemLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setupMyCartLabelConstraints() {
        myCartLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myCartLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            myCartLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setupTotalPriceConstraints() {
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            totalPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            totalPriceLabel.firstBaselineAnchor.constraint(equalTo: myCartLabel.firstBaselineAnchor)
        ])
    }
}

extension MyCartButton: ViewConfiguration {
    func setupConstraints() {
        setupButtonConstraints()
        setupItemLabelConstraints()
        setupMyCartLabelConstraints()
        setupTotalPriceConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(itemLabel)
        addSubview(myCartLabel)
        addSubview(totalPriceLabel)
    }
    
    func configureViews() {
        backgroundColor = .red
    }
}
