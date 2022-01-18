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
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    // MARK: - Setup Constraints
    
    func setupAddressTextFieldConstraints() {
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressTextField.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            addressTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            addressTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            addressTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupNeighborhoodTextFieldConstraints() {
        neighborhoodTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            neighborhoodTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 10),
            neighborhoodTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            neighborhoodTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            neighborhoodTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupSaveLocationDeliveryButtonConstraints() {
        saveLocationDeliveryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveLocationDeliveryButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            saveLocationDeliveryButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

extension DeliveryLocationView: ViewConfiguration {
    func setupConstraints() {
        setupAddressTextFieldConstraints()
        setupNeighborhoodTextFieldConstraints()
        setupSaveLocationDeliveryButtonConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(addressTextField)
        addSubview(neighborhoodTextField)
        addSubview(saveLocationDeliveryButton)
    }
    
    func configureViews() {
        backgroundColor = .white
    }
}
