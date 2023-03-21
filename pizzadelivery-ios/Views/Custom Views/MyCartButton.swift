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
        self.setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    func configure(quantity: String, totalPrice: String) {
        self.itemLabel.text = "\(Int(quantity)! == 1 ? "\(quantity) item" : " \(quantity) itens")"
        self.totalPriceLabel.text = "R$ \(totalPrice)"
    }
    
    // MARK: - Setup Constraints
    
    func setupButtonConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupItemLabelConstraints() {
        self.itemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.itemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            self.itemLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setupMyCartLabelConstraints() {
        self.myCartLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.myCartLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.myCartLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setupTotalPriceConstraints() {
        self.totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.totalPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            self.totalPriceLabel.firstBaselineAnchor.constraint(equalTo: self.myCartLabel.firstBaselineAnchor)
        ])
    }
}

extension MyCartButton: ViewConfiguration {
    func setupConstraints() {
        self.setupButtonConstraints()
        self.setupItemLabelConstraints()
        self.setupMyCartLabelConstraints()
        self.setupTotalPriceConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(self.itemLabel)
        addSubview(self.myCartLabel)
        addSubview(self.totalPriceLabel)
    }
    
    func configureViews() {
        backgroundColor = .red
        isHidden = true
        self.myCartLabel.text = "Meu carrinho"
    }
}
