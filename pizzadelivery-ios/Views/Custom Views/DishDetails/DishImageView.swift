//
//  DishImageView.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 11/01/22.
//

import UIKit

class DishImageView: UIImageView {
    
    // MARK: - Views
    
    let dishImageView: UIImageView = {
        let dishImageView = UIImageView(image: UIImage(named: "pizza3"))
        dishImageView.contentMode = .scaleAspectFill
        dishImageView.clipsToBounds = true
        return dishImageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    // MARK: - Setup Constraints
    
    private func setupDishImageViewConstraints() {
        dishImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dishImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            dishImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            dishImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            dishImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}

extension DishImageView: ViewConfiguration {
    func setupConstraints() {
        setupDishImageViewConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(dishImageView)
    }
    
    func configureViews() {
        backgroundColor = .red
    }
}
