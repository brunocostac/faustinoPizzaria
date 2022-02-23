//
//  MyCartButton.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 12/01/22.
//
import UIKit

class MyCartButton: UIButton {
    
    // MARK: - Views
    
    private let myCartLabel: UILabel = MyLabel(font: UIFont(name: "Avenir-Heavy", size: 16)!, textColor: .white, numberOfLines: 0)
    private let itemLabel: UILabel = MyLabel(font: UIFont(name: "Avenir-Heavy", size: 16)!, textColor: .white, numberOfLines: 0)
    private let totalPriceLabel: UILabel = MyLabel(font: UIFont(name: "Avenir-Heavy", size: 16)!, textColor: .white, numberOfLines: 0)
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    func configureWithText(quantity: String, totalPrice: String) {
        itemLabel.text = "\(Int(quantity)! == 1 ? "\(quantity) item" : " \(quantity) itens")"
        totalPriceLabel.text = "R$ \(totalPrice)"
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
        isHidden = true
        myCartLabel.text = "Meu carrinho"
    }
}
