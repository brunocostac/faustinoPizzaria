//
//  DishImageView.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 11/01/22.
//

import UIKit

class DishImageView: UIImageView {
    
    // MARK: - Views
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    // MARK: - Functions
    
    func configureWith(url: String) {
        self.imageView.image = UIImage(named: url)
    }
    
    // MARK: - Setup Constraints
    
    private func setupDishImageViewConstraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            self.imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            self.imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            self.imageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}

extension DishImageView: ViewConfiguration {
    func setupConstraints() {
        self.setupDishImageViewConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(self.imageView)
    }
    
    func configureViews() {
        backgroundColor = .lightGray
    }
}
