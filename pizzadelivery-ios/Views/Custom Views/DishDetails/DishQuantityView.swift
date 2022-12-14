//
//  DishQuantityView.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 11/01/22.
//

import UIKit

class DishQuantityView: UIView {
    
    // MARK: - Views
    
    let decreaseButton: UIButton = {
        let decreaseButton = UIButton()
        decreaseButton.setTitle("-", for: .normal)
        decreaseButton.backgroundColor = .darkGray
        decreaseButton.titleLabel?.textColor = .white
        return decreaseButton
    }()
    
    let quantityLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 29)!, textColor: .black, numberOfLines: 0)
    
    let increaseButton: UIButton = {
        let increaseButton = UIButton()
        increaseButton.setTitle("+", for: .normal)
        increaseButton.backgroundColor = .darkGray
        increaseButton.titleLabel?.textColor = .white
        return increaseButton
    }()
    
    let addToCartButton: UIButton = {
        let addToCartButton = UIButton()
        addToCartButton.setTitle("Adicionar R$ 35,90", for: .normal)
        addToCartButton.backgroundColor = .red
        addToCartButton.titleLabel?.textColor = .white
        addToCartButton.layer.cornerRadius =  20
        addToCartButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return addToCartButton
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
        self.quantityLabel.text = "1"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    func configureAddToCartButtonWith(flag: ItemOrderStatus, price: String) {
        self.addToCartButton.setTitle("\(flag.rawValue) R$ \(price)", for: .normal)
    }
    
    // MARK: - Setup Constraints
    
    func setupDecreaseButtonConstraints() {
        self.decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.decreaseButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            self.decreaseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    func setupQuantityLabelConstraints() {
        self.quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.quantityLabel.firstBaselineAnchor.constraint(equalTo: self.decreaseButton.firstBaselineAnchor),
            self.quantityLabel.centerYAnchor.constraint(equalTo: self.decreaseButton.centerYAnchor),
            self.quantityLabel.leadingAnchor.constraint(equalTo: self.decreaseButton.leadingAnchor, constant: 45)
        ])
    }
    
    func setupIncreaseButtonConstraints() {
        self.increaseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.increaseButton.firstBaselineAnchor.constraint(equalTo: self.quantityLabel.firstBaselineAnchor),
            self.increaseButton.leadingAnchor.constraint(equalTo: self.quantityLabel.leadingAnchor, constant: 30)
        ])
    }
    
    func setupAddToCartButtonConstraints() {
        self.addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.addToCartButton.firstBaselineAnchor.constraint(equalTo: self.increaseButton.firstBaselineAnchor),
            self.addToCartButton.leadingAnchor.constraint(equalTo: self.increaseButton.leadingAnchor, constant: 50),
            self.addToCartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 150)
    }
}

extension DishQuantityView: ViewConfiguration {
    func setupConstraints() {
        self.setupDecreaseButtonConstraints()
        self.setupQuantityLabelConstraints()
        self.setupIncreaseButtonConstraints()
        self.setupAddToCartButtonConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(self.decreaseButton)
        addSubview(self.quantityLabel)
        addSubview(self.increaseButton)
        addSubview(self.addToCartButton)
    }
    
    func configureViews() {
        backgroundColor = .white
    }
}
