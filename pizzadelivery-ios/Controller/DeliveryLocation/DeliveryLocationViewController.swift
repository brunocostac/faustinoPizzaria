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
    
    // MARK: - Views
    
    let deliveryLocationView = DeliveryLocationView()
    var coordinator: MenuBaseCoordinator?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrder()
        populateTextFields()
    }
    
    // MARK: - Initialization
    
    required init(coordinator: MenuBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchOrder() {
        orderViewModel = CoreDataHelper().fetchCurrentOrder()
    }
    
    func populateTextFields() {
        if let orderVM = orderViewModel?.order {
            deliveryLocationView.addressTextField.text = orderVM.address
            deliveryLocationView.neighborhoodTextField.text = orderVM.neighborhood
            deliveryLocationView.customerNameTextField.text = orderVM.customerName
        }
    }
    
    // MARK: - Setup Constraints
    
    func setupDeliveryLocationViewConstraints() {
        deliveryLocationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deliveryLocationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            deliveryLocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deliveryLocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deliveryLocationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension DeliveryLocationViewController: ViewConfiguration {
    func setupConstraints() {
        setupDeliveryLocationViewConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(deliveryLocationView)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        title = "Local de entrega"
        deliveryLocationView.saveLocationDeliveryButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
}

// MARK: - User Actions

extension DeliveryLocationViewController {
    @objc func saveButtonPressed() {
        if let address = deliveryLocationView.addressTextField.text,
           let neighborhood = deliveryLocationView.neighborhoodTextField.text,
           let customerName = deliveryLocationView.customerNameTextField.text {
            orderViewModel?.order.address = address
            orderViewModel?.order.neighborhood = neighborhood
            orderViewModel?.order.customerName = customerName
            CoreDataHelper().updateOrder(orderViewModel: orderViewModel)
        }
        goToCartScreen()
    }
    
    @objc func goToCartScreen() {
        coordinator?.moveTo(flow: .menu(.cartScreen), data: [])
    }
}
