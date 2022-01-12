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
        setupViewConfiguration()
        quantityLabel.text = "1"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    // MARK: - Setup Constraints
    
    func setupDecreaseButtonConstraints() {
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            decreaseButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            decreaseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    func setupQuantityLabelConstraints() {
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quantityLabel.firstBaselineAnchor.constraint(equalTo: decreaseButton.firstBaselineAnchor),
            quantityLabel.centerYAnchor.constraint(equalTo: decreaseButton.centerYAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: decreaseButton.leadingAnchor, constant: 45)
        ])
    }
    
    func setupIncreaseButtonConstraints() {
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            increaseButton.firstBaselineAnchor.constraint(equalTo: quantityLabel.firstBaselineAnchor),
            increaseButton.leadingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: 30)
        ])
    }
    
    func setupAddToCartButtonConstraints() {
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addToCartButton.firstBaselineAnchor.constraint(equalTo: increaseButton.firstBaselineAnchor),
            addToCartButton.leadingAnchor.constraint(equalTo: increaseButton.leadingAnchor, constant: 50),
            addToCartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 150)
    }
}

extension DishQuantityView: ViewConfiguration {
    func setupConstraints() {
        setupDecreaseButtonConstraints()
        setupQuantityLabelConstraints()
        setupIncreaseButtonConstraints()
        setupAddToCartButtonConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(decreaseButton)
        addSubview(quantityLabel)
        addSubview(increaseButton)
        addSubview(addToCartButton)
    }
    
    func configureViews() {
        backgroundColor = .white
    }
}
