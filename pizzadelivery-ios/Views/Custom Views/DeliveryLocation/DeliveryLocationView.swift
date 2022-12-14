//
//  DeliveryLocation.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 17/01/22.
//

import UIKit

class DeliveryLocationView: UIView {
    
    // MARK: - Views
    
    let addressTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Endereço"
        textField.textAlignment = .center
        return textField
    }()
    
    let neighborhoodTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Bairro"
        textField.textAlignment = .center
        return textField
    }()
    
    let customerNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.placeholder = "Nome de quem vai receber"
        textField.textAlignment = .center
        return textField
    }()
    
    let saveLocationDeliveryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Salvar", for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius =  20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return button
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
    
    func setupAddressTextFieldConstraints() {
        self.addressTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.addressTextField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            self.addressTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            self.addressTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            self.addressTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupNeighborhoodTextFieldConstraints() {
        self.neighborhoodTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.neighborhoodTextField.topAnchor.constraint(equalTo: self.addressTextField.bottomAnchor, constant: 10),
            self.neighborhoodTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            self.neighborhoodTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            self.neighborhoodTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupCustomerTextFieldConstraints() {
        self.customerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.customerNameTextField.topAnchor.constraint(equalTo: self.neighborhoodTextField.bottomAnchor, constant: 10),
            self.customerNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            self.customerNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            self.customerNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupSaveLocationDeliveryButtonConstraints() {
        self.saveLocationDeliveryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.saveLocationDeliveryButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            self.saveLocationDeliveryButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

extension DeliveryLocationView: ViewConfiguration {
    func setupConstraints() {
        self.setupAddressTextFieldConstraints()
        self.setupNeighborhoodTextFieldConstraints()
        self.setupCustomerTextFieldConstraints()
        self.setupSaveLocationDeliveryButtonConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(self.addressTextField)
        addSubview(self.neighborhoodTextField)
        addSubview(self.customerNameTextField)
        addSubview(self.saveLocationDeliveryButton)
    }
    
    func configureViews() {
        backgroundColor = .white
    }
}
