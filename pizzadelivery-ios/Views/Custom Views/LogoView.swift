//
//  LogoView.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import UIKit

class LogoView: UIView {
    
    // MARK: - Views
    
    private let backgroundImage: UIImageView = {
        let backgroundImage = UIImageView(image: UIImage(named: "backgroundImage"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        return backgroundImage
    }()
    
    private let logoImage: UIImageView = {
        let logoImage = UIImageView(image: UIImage(named: "logoImage"))
        logoImage.contentMode = .scaleAspectFill
        logoImage.clipsToBounds = true
        return logoImage
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    // MARK: - Setup Constraints
    
    private func setupHeaderImageConstraints() {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backgroundImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            backgroundImage.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            backgroundImage.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    private func setupLogoConstraints() {
        logoImage.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor),
            logoImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 25),
            logoImage.heightAnchor.constraint(equalToConstant: 80),
            logoImage.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}

// MARK: - ViewConfiguration

extension LogoView: ViewConfiguration {
    func setupConstraints() {
        setupHeaderImageConstraints()
        setupLogoConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(backgroundImage)
        addSubview(logoImage)
    }
    
    func configureViews() {
        backgroundColor = . white
    }
}
