//
//  SendOrderButton.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 22/02/22.
//

import UIKit

class FooterView: UIView {
    
    // MARK: - Views
    let footerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ir para o pagamento", for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius =  20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return button
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
    func setupFooterButtonConstraints() {
       footerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            footerButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

extension FooterView: ViewConfiguration {
    func setupConstraints() {
        setupFooterButtonConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(footerButton)
    }
    
    func configureViews() {
        backgroundColor = .white
    }
}
