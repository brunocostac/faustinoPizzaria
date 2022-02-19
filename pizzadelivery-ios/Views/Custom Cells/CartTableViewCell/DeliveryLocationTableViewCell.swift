//
//  DeliveryPlaceTableViewCell.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 14/01/22.
//

import UIKit

protocol DeliveryLocationTableViewCellDelegate: AnyObject {
    func goToNextScreen()
    func goToDeliveryLocationScreen()
}

class DeliveryLocationTableViewCell: UITableViewCell {

    weak var delegate: DeliveryLocationTableViewCellDelegate?
    
    // MARK: - Views
    let placeDescriptionLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 14)!, textColor: .black, numberOfLines: 0)
    
    let editDeliveryLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        return button
    }()
    
    let goToPaymentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ir para o pagamento", for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius =  20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
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
    
    @objc func editDeliveryLocationButtonClicked() {
        delegate?.goToDeliveryLocationScreen()
    }
    
    @objc func goToNextScreenButtonClicked() {
        delegate?.goToNextScreen()
    }
    
    // MARK: - Setup Constraints
    
    func setupPlaceDescriptionLabelConstraints() {
        placeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeDescriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            placeDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    func setupAddLocalDeliveryButtonConstraints() {
        editDeliveryLocationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editDeliveryLocationButton.firstBaselineAnchor.constraint(equalTo: placeDescriptionLabel.firstBaselineAnchor),
            editDeliveryLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func setupGoToPaymentButtonConstraints() {
        goToPaymentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goToPaymentButton.topAnchor.constraint(equalTo: placeDescriptionLabel.bottomAnchor, constant: 20),
            goToPaymentButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            goToPaymentButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

extension DeliveryLocationTableViewCell: ViewConfiguration {
    
    func setupConstraints() {
        setupPlaceDescriptionLabelConstraints()
        setupAddLocalDeliveryButtonConstraints()
        setupGoToPaymentButtonConstraints()
    }
    
    func buildViewHierarchy() {
        contentView.isUserInteractionEnabled = true
        addSubview(placeDescriptionLabel)
        addSubview(editDeliveryLocationButton)
        addSubview(goToPaymentButton)
    }
    
    func configureViews() {
        backgroundColor = .white
        goToPaymentButton.addTarget(self, action: #selector(goToNextScreenButtonClicked), for: .touchUpInside)
        editDeliveryLocationButton.addTarget(self, action: #selector(editDeliveryLocationButtonClicked), for: .touchUpInside)
    }
}
