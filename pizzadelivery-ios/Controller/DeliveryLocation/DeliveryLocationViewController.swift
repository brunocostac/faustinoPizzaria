//
//  DeliveryLocationViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 14/01/22.
//

import UIKit

class DeliveryLocationViewController: UIViewController, MenuBaseCoordinated {
    
    // MARK: - ViewModel
    
    var orderViewModel: OrderViewModel?
    
    // MARK: - Variables
    var previousScreen: MenuScreen?
    
    // MARK: - Views
    
    let deliveryLocationView = DeliveryLocationView()
    var coordinator: MenuBaseCoordinator?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchOrder()
        self.populateTextFields()
    }
    
    // MARK: - Initialization
    
    required init(coordinator: MenuBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func populateTextFields() {
        if let orderVM = orderViewModel?.order {
            self.deliveryLocationView.addressTextField.text = orderVM.address
            self.deliveryLocationView.neighborhoodTextField.text = orderVM.neighborhood
            self.deliveryLocationView.customerNameTextField.text = orderVM.customerName
        }
    }
    
    // MARK: - Setup Constraints
    
    private func setupDeliveryLocationViewConstraints() {
        self.deliveryLocationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.deliveryLocationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.deliveryLocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.deliveryLocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.deliveryLocationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension DeliveryLocationViewController: ViewConfiguration {
    func setupConstraints() {
        self.setupDeliveryLocationViewConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(self.deliveryLocationView)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        title = "Local de entrega"
        self.deliveryLocationView.saveLocationDeliveryButton.addTarget(self, action: #selector(self.saveButtonPressed), for: .touchUpInside)
    }
}

// MARK: - CoreData

extension DeliveryLocationViewController {
    private func fetchOrder() {
        OrderRepository().fetch{ orderVM in
            self.orderViewModel = orderVM
        }
    }
    
    private func saveOrder() {
        OrderRepository().update(orderViewModel: orderViewModel, completion: { success in
            if success {
                self.goToPreviousScreen()
            }
        })
    }
}

// MARK: - User Actions

extension DeliveryLocationViewController {
    @objc func saveButtonPressed() {
        if let address = self.deliveryLocationView.addressTextField.text,
           let neighborhood = self.deliveryLocationView.neighborhoodTextField.text,
           let customerName = self.deliveryLocationView.customerNameTextField.text {
            
            self.orderViewModel?.order.address = address
            self.orderViewModel?.order.neighborhood = neighborhood
            self.orderViewModel?.order.customerName = customerName
            self.saveOrder()
        }
    }
    
    @objc func goToPreviousScreen() {
        coordinator?.moveTo(flow: .menu(previousScreen!), data: [])
    }
}
