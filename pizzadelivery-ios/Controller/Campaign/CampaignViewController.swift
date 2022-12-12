//
//  CampaignViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import UIKit

class CampaignViewController: UIViewController, CampaignBaseCoordinated {
    
    // MARK: - Views
    
    var coordinator: CampaignBaseCoordinator?
    private let logoView = LogoView()
    private let firstPromotionalCampaign: UIImageView = {
        let image = UIImageView(image: UIImage(named: "promo1"))
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    private let secondPromotionalCampaign: UIImageView = {
        let image = UIImageView(image: UIImage(named: "promo2"))
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Initialization
    
    required init(coordinator: CampaignBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewConfiguration

extension CampaignViewController: ViewConfiguration {
    func setupConstraints() {
        firstPromotionalCampaign.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstPromotionalCampaign.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            firstPromotionalCampaign.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            firstPromotionalCampaign.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            firstPromotionalCampaign.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        secondPromotionalCampaign.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondPromotionalCampaign.topAnchor.constraint(equalTo: firstPromotionalCampaign.bottomAnchor, constant: 0),
            secondPromotionalCampaign.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            secondPromotionalCampaign.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            secondPromotionalCampaign.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    func buildViewHierarchy() {
        view.addSubview(firstPromotionalCampaign)
        view.addSubview(secondPromotionalCampaign)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        title = "Promoções"
    }
}
