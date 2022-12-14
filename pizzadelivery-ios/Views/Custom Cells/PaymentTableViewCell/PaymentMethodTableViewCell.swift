//
//  PaymentTableViewCell.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 17/01/22.
//

import UIKit

protocol PaymentMethodTableViewCellDelegate: AnyObject {
    func getPaymentSelected(id: String)
}

class PaymentMethodTableViewCell: UITableViewCell {
    
    weak var delegate: PaymentMethodTableViewCellDelegate?
    
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
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    @objc func firstPaymentMethodWasSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.paymentMethodTwoButton.isSelected = false
        self.delegate?.getPaymentSelected(id: "0")
    }
    
    @objc func secondPaymentMethodWasSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.paymentMethodOneButton.isSelected = false
        self.delegate?.getPaymentSelected(id: "1")
    }
    
    // MARK: - Setup Constraints
    func setupOptionOneButtonConstraints() {
        paymentMethodOneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.paymentMethodOneButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            self.paymentMethodOneButton.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    func setupOptionTwoButtonConstraints() {
        self.paymentMethodTwoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.paymentMethodTwoButton.firstBaselineAnchor.constraint(equalTo: paymentMethodOneButton.firstBaselineAnchor),
            self.paymentMethodTwoButton.leadingAnchor.constraint(equalTo: self.paymentMethodOneButton.trailingAnchor, constant: 10)
        ])
    }
}

extension PaymentMethodTableViewCell: ViewConfiguration {
    func setupConstraints() {
        self.setupOptionOneButtonConstraints()
        self.setupOptionTwoButtonConstraints()
    }
    
    func buildViewHierarchy() {
        contentView.isUserInteractionEnabled = true
        addSubview(self.paymentMethodOneButton)
        addSubview(self.paymentMethodTwoButton)
    }
    
    func configureViews() {
        backgroundColor = .white
        selectionStyle = .none
        self.paymentMethodOneButton.addTarget(self, action: #selector(self.firstPaymentMethodWasSelected(_:)), for: .touchUpInside)
        self.paymentMethodTwoButton.addTarget(self, action: #selector(self.secondPaymentMethodWasSelected(_:)), for: .touchUpInside)
        self.paymentMethodOneButton.isSelected = true
    }
}
