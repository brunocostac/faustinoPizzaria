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
    let titleLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 16)!, textColor: .black, numberOfLines: 1)
    let descriptionLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 14)!, textColor: .gray, numberOfLines: 2)
    let priceLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 16)!, textColor: .black, numberOfLines: 0)
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Constraints
    
    private func setupDishImageConstraints() {
        dishImage.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            dishImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dishImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            dishImage.heightAnchor.constraint(equalToConstant: 60),
            dishImage.widthAnchor.constraint(equalTo: dishImage.heightAnchor, multiplier: 16/9)
        ])
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            titleLabel.firstBaselineAnchor.constraint(equalTo: dishImage.firstBaselineAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: dishImage.trailingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    private func setupDescriptionLabelConstraints() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: dishImage.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        ])
    }
    
    private func setupPriceLabelConstraints() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - ViewConfiguration

extension MenuTableViewCell: ViewConfiguration {
    func setupConstraints() {
        setupDishImageConstraints()
        setupTitleLabelConstraints()
        setupDescriptionLabelConstraints()
        setupPriceLabelConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(dishImage)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(priceLabel)
    }
    
    func configureViews() {
        backgroundColor = .white
        selectionStyle = .none
    }
}
