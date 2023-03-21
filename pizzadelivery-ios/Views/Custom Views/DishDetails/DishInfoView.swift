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
        self.setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    // MARK: - Functions
    
    func configure(name: String, description: String, price: String) {
        self.nameLabel.text = name
        self.descriptionLabel.text = description
        self.priceLabel.text = "R$ \(price)"
    }
    
    // MARK: - Setup Constraints
    
    func setupNameLabelConstraints() {
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            self.nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    func setupDescriptionLabelConstraints() {
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func setupPriceLabelConstraints() {
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.priceLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 10),
            self.priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            self.priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 150)
    }
}

extension DishInfoView: ViewConfiguration {
    func setupConstraints() {
        self.setupNameLabelConstraints()
        self.setupDescriptionLabelConstraints()
        self.setupPriceLabelConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(self.nameLabel)
        addSubview(self.descriptionLabel)
        addSubview(self.priceLabel)
    }
    
    func configureViews() {
        backgroundColor = .white
    }
}
