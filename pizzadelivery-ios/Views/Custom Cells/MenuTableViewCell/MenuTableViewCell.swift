//
//  MenuTableViewCell.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 07/01/22.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    let dishImage: UIImageView = {
        let dishImage = UIImageView()
        dishImage.clipsToBounds = true
        return dishImage
    }()
    let titleLabel: UILabel = MyLabel(font: UIFont(name: "avenir-heavy", size: 14)!, textColor: .systemGray, numberOfLines: 1)
    let descriptionLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 15)!, textColor: .gray, numberOfLines: 2)
    let priceLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 16)!, textColor: .black, numberOfLines: 0)
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWith(name: String, description: String, price: String, image: UIImage) {
        self.titleLabel.text = name
        self.dishImage.image = image
        self.descriptionLabel.text = description
        self.priceLabel.text = price
    }
    
    // MARK: - Setup Constraints
    
    private func setupDishImageConstraints() {
        self.dishImage.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            self.dishImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            self.dishImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            self.dishImage.heightAnchor.constraint(equalToConstant: 60),
            self.dishImage.widthAnchor.constraint(equalTo:  self.dishImage.heightAnchor, multiplier: 16/9)
        ])
    }
    
    private func setupTitleLabelConstraints() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            self.titleLabel.firstBaselineAnchor.constraint(equalTo: self.dishImage.firstBaselineAnchor, constant: 5),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.dishImage.trailingAnchor, constant: 20),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 60),
            self.titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    private func setupDescriptionLabelConstraints() {
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.dishImage.bottomAnchor, constant: 10),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        ])
    }
    
    private func setupPriceLabelConstraints() {
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            self.priceLabel.topAnchor.constraint(equalTo:  self.descriptionLabel.bottomAnchor, constant: 10),
            self.priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            self.priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            self.priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - ViewConfiguration

extension MenuTableViewCell: ViewConfiguration {
    func setupConstraints() {
        self.setupDishImageConstraints()
        self.setupTitleLabelConstraints()
        self.setupDescriptionLabelConstraints()
        self.setupPriceLabelConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(self.dishImage)
        addSubview(self.titleLabel)
        addSubview(self.descriptionLabel)
        addSubview(self.priceLabel)
    }
    
    func configureViews() {
        backgroundColor = .white
        selectionStyle = .none
    }
}
