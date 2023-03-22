//
//  DeliveryLocationViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 14/01/22.
//

import UIKit

class DeliveryLocationViewController: UIViewController, HomeBaseCoordinated, DeliveryLocationViewModelDelegate {
    
    // MARK: - ViewModel
    var deliveryLocationVM = DeliveryLocationViewModel()
    
    // MARK: - Variables
    var previousScreen: HomeScreen?
    
    // MARK: - Views
    
    let deliveryLocationView = DeliveryLocationView()
    var coordinator: HomeBaseCoordinator?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFields()
        self.setupToHideKeyboardOnTapOnView()
        self.setupViewConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.deliveryLocationVM = DeliveryLocationViewModel()
        self.deliveryLocationVM.delegate = self
        self.deliveryLocationVM.viewDidAppear()
    }
    
    // MARK: - Initialization
    
    required init(coordinator: HomeBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextFields() {
        self.deliveryLocationView.neighborhoodTextField.delegate = self
        self.deliveryLocationView.customerNameTextField.delegate = self
    }
    
    internal func didPopulateTextFields(address: String, neighborhood: String, customerName: String) {
        self.deliveryLocationView.addressTextField.text = address
        self.deliveryLocationView.neighborhoodTextField.text = neighborhood
        self.deliveryLocationView.customerNameTextField.text = customerName
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

extension DeliveryLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
// MARK: - User Actions

extension DeliveryLocationViewController {
    @objc func saveButtonPressed() {
        let address = self.deliveryLocationView.addressTextField.text
        let neighborhood = self.deliveryLocationView.neighborhoodTextField.text
        let customerName = self.deliveryLocationView.customerNameTextField.text
        
        self.deliveryLocationVM.saveOrder(address: address!, neighborhood: neighborhood!, customerName: customerName!)
    }
    
    @objc func didGoToPreviousScreen() {
        coordinator?.moveTo(flow: .home(previousScreen!), data: [])
    }
    
    func didDisplayAlert() {
        let alert = UIAlertController(title: "Informação", message: "Favor, Preencher todos os campos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
