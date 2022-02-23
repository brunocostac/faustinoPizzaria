//
//  DishInfoView.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 11/01/22.
//

import UIKit

class DishInfoView: UIView {
    
    // MARK: - Views
    
    let nameLabel: UILabel = MyLabel(font: UIFont(name: "avenir-heavy", size: 21)!, textColor: .black, numberOfLines: 0)
    let descriptionLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 18)!, textColor: .lightGray, numberOfLines: 0)
    let priceLabel: UILabel = MyLabel(font: UIFont(name: "avenir-heavy", size: 18)!, textColor: .lightGray, numberOfLines: 0)
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    // MARK: - Functions
    
    func configureLayout(name: String, description: String, price: Double) {
        nameLabel.text = name
        descriptionLabel.text = description
        priceLabel.text = "R$ \(price)"
    }
    
    // MARK: - Setup Constraints
    
    func setupNameLabelConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    func setupDescriptionLabelConstraints() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func setupPriceLabelConstraints() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 150)
    }
}

extension DishInfoView: ViewConfiguration {
    func setupConstraints() {
        setupNameLabelConstraints()
        setupDescriptionLabelConstraints()
        setupPriceLabelConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(priceLabel)
    }
    
    func configureViews() {
        backgroundColor = .white
    }
}
