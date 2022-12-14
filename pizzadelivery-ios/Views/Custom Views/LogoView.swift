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
        logoImage.contentMode = .scaleAspectFit
        logoImage.clipsToBounds = true
        return logoImage
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    // MARK: - Setup Constraints
    
    private func setupHeaderImageConstraints() {
        self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            self.backgroundImage.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            self.backgroundImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            self.backgroundImage.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            self.backgroundImage.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    private func setupLogoConstraints() {
        self.logoImage.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            self.logoImage.centerXAnchor.constraint(equalTo: self.backgroundImage.centerXAnchor),
            self.logoImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 25),
            self.logoImage.heightAnchor.constraint(equalToConstant: 80),
            self.logoImage.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}

// MARK: - ViewConfiguration

extension LogoView: ViewConfiguration {
    func setupConstraints() {
        self.setupHeaderImageConstraints()
        self.setupLogoConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(self.backgroundImage)
        addSubview(self.logoImage)
    }
    
    func configureViews() {
        backgroundColor = . white
    }
}
