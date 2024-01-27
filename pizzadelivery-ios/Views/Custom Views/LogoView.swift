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
            self.backgroundImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.backgroundImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            self.backgroundImage.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            self.backgroundImage.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
}

// MARK: - ViewConfiguration

extension LogoView: ViewConfiguration {
    func setupConstraints() {
        self.setupHeaderImageConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(self.backgroundImage)
    }
    
    func configureViews() {
        backgroundColor = . white
    }
}
