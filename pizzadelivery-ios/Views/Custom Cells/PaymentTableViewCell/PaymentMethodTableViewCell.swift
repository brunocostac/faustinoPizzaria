//
//  PaymentTableViewCell.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 17/01/22.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    let paymentMethodOneButton: UIButton = {
       let button = UIButton()
       button.translatesAutoresizingMaskIntoConstraints = false
       button.setImage(UIImage(named: "radiobutton-normal"), for: .normal)
       button.setImage(UIImage(named: "radiobutton-selected"), for: .selected)
       button.setTitle("Dinheiro", for: .normal)
       button.titleLabel?.font = UIFont(name: "Avenir", size: 16)
       button.setTitleColor(.black, for: .normal)
       button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
       return button
    }()
    
    let paymentMethodTwoButton: UIButton = {
       let button = UIButton()
       button.translatesAutoresizingMaskIntoConstraints = false
       button.setImage(UIImage(named: "radiobutton-normal"), for: .normal)
       button.setImage(UIImage(named: "radiobutton-selected"), for: .selected)
       button.setTitle("Cartão de crédito ou débito", for: .normal)
       button.titleLabel?.font = UIFont(name: "Avenir", size: 15)
       button.setTitleColor(.black, for: .normal)
       button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
       return button
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    @objc func firstPaymentMethodWasSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        paymentMethodTwoButton.isSelected = false
    }
    
    @objc func secondPaymentMethodWasSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        paymentMethodOneButton.isSelected = false
    }
    
    // MARK: - Setup Constraints
    func setupOptionOneButtonConstraints() {
        paymentMethodOneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            paymentMethodOneButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            paymentMethodOneButton.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    func setupOptionTwoButtonConstraints() {
        paymentMethodTwoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            paymentMethodTwoButton.firstBaselineAnchor.constraint(equalTo: paymentMethodOneButton.firstBaselineAnchor),
            paymentMethodTwoButton.leadingAnchor.constraint(equalTo: paymentMethodOneButton.trailingAnchor, constant: 10)
        ])
    }
}

extension PaymentMethodTableViewCell: ViewConfiguration {
    func setupConstraints() {
        setupOptionOneButtonConstraints()
        setupOptionTwoButtonConstraints()
    }
    
    func buildViewHierarchy() {
        contentView.isUserInteractionEnabled = true
        addSubview(paymentMethodOneButton)
        addSubview(paymentMethodTwoButton)
    }
    
    func configureViews() {
        backgroundColor = .white
        paymentMethodOneButton.addTarget(self, action: #selector(firstPaymentMethodWasSelected(_:)), for: .touchUpInside)
        paymentMethodTwoButton.addTarget(self, action: #selector(secondPaymentMethodWasSelected(_:)), for: .touchUpInside)
    }
}
