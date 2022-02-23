//
//  DeliveryPlaceTableViewCell.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 14/01/22.
//

import UIKit

protocol DeliveryLocationTableViewCellDelegate: AnyObject {
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
}

extension DeliveryLocationTableViewCell: ViewConfiguration {
    
    func setupConstraints() {
        setupPlaceDescriptionLabelConstraints()
        setupAddLocalDeliveryButtonConstraints()
    }
    
    func buildViewHierarchy() {
        contentView.isUserInteractionEnabled = true
        addSubview(placeDescriptionLabel)
        addSubview(editDeliveryLocationButton)
    }
    
    func configureViews() {
        backgroundColor = .white
        editDeliveryLocationButton.addTarget(self, action: #selector(editDeliveryLocationButtonClicked), for: .touchUpInside)
    }
}
