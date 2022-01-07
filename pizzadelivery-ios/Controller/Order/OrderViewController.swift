//
//  OrderViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import UIKit

class OrderViewController: UIViewController, OrderBaseCoordinated {
    
    // MARK: - Views
    
    var coordinator: OrderBaseCoordinator?
    
    private let logoView = LogoView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfiguration()
    }
    
    // MARK: - Initialization
    
    required init(coordinator: OrderBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewConfiguration

extension OrderViewController: ViewConfiguration {
    func setupConstraints() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
               
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            logoView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    func buildViewHierarchy() {
        view.addSubview(logoView)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        title = "Pedidos"
    }
}
