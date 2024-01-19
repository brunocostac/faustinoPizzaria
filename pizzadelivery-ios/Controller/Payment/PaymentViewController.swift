//
//  PaymentViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 17/01/22.
//

import UIKit

class PaymentViewController: UIViewController, HomeBaseCoordinated, PaymentViewModelDelegate {

    // MARK: - ViewModels
    private var paymentViewModel: PaymentViewModel?
    
    // MARK: - Variables
    
    private var paymentSelected: String = "0"
    
    // MARK: - Views
    
    var coordinator: HomeBaseCoordinator?
    
    private let logoView = LogoView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let tableHeaderView = HeaderView()
    private let tableFooterView = FooterView()
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.tintColor = .black
        spinner.style = .large
        return spinner
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.paymentViewModel = PaymentViewModel()
        self.paymentViewModel?.delegate = self
        self.paymentViewModel?.viewDidAppear()
        self.setupTableView()
        self.spinner.stopAnimating()
    }
    
    required init(coordinator: HomeBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.tableFooterView = self.tableFooterView
        self.tableView.backgroundColor = .white
        self.tableView.register(PaymentMethodTableViewCell.self, forCellReuseIdentifier: "PaymentMethodTableViewCell")
        self.tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: "CartItemTableViewCell")
        self.tableView.register(TotalPriceTableViewCell.self, forCellReuseIdentifier: "TotalPriceTableViewCell")
        self.tableView.register(DeliveryLocationTableViewCell.self, forCellReuseIdentifier: "DeliveryLocationTableViewCell")
    }
    
    
    func didDisplayAlert(title: String, message: String, actionClosure: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction!) in actionClosure()}))
        
        self.present(alertController, animated: true)
    }
    
    // MARK: - Setup Constraints
    
    func setupLogoConstraints() {
        self.logoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            self.logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            self.logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            self.logoView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func setupTableViewConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.logoView.bottomAnchor, constant: 40),
            self.tableView.leadingAnchor.constraint(equalTo: self.logoView.leadingAnchor, constant: 0),
            self.tableView.trailingAnchor.constraint(equalTo: self.logoView.trailingAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupSpinnerConstraints() {
        self.spinner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - ViewConfiguration

extension PaymentViewController: ViewConfiguration {
    func setupConstraints() {
        self.setupLogoConstraints()
        self.setupTableViewConstraints()
        self.setupSpinnerConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(self.logoView)
        view.addSubview(self.tableView)
        view.addSubview(self.spinner)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        self.tableFooterView.footerButton.setTitle("Enviar o pedido", for: .normal)
        self.tableFooterView.footerButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
}

// MARK: - UITableViewDelegate
extension PaymentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 160
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            return nil
        case 2:
            return self.tableFooterView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            return 60
        default:
            return 0
        }
    }
}

// MARK: - UITableViewDataSource
extension PaymentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return paymentViewModel?.section[section]
        case 1:
            return paymentViewModel?.section[section]
        case 2:
            return paymentViewModel?.section[section]
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return (self.paymentViewModel?.itemOrderListViewModel.count)! + 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell0 = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as? PaymentMethodTableViewCell else {
                return UITableViewCell()
            }
            cell0.delegate = self
            return cell0
        case 1:
            if (self.paymentViewModel?.itemOrderListViewModel.count)! >= indexPath.row + 1 {
                guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "CartItemTableViewCell", for: indexPath) as? CartItemTableViewCell else {
                    return UITableViewCell()
                }
                
                let itemInCart = self.paymentViewModel?.itemOrderListViewModel.itemOrderAtIndex(indexPath.row)
                cell1.configureWithText(itemDescription: itemInCart!.itemDescription, itemTotal: itemInCart!.itemTotal)
                
                return cell1
            } else {
                guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "TotalPriceTableViewCell", for: indexPath) as? TotalPriceTableViewCell else {
                    return UITableViewCell()
                }
                cell2.configureWithText(subTotalOrder: (self.paymentViewModel?.itemOrderListViewModel.totalItemOrder)!, totalOrder: (self.paymentViewModel?.itemOrderListViewModel.totalItemOrder)!, fee: "0.00")
                return cell2
            }
        case 2:
            guard let cell3 = tableView.dequeueReusableCell(withIdentifier:
            "DeliveryLocationTableViewCell", for: indexPath) as? DeliveryLocationTableViewCell else {
                return UITableViewCell()
            }
            cell3.delegate = self 
            cell3.configureWithText(address: (self.paymentViewModel?.orderViewModel.getAddressMessage())!)
            
            return cell3
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - User Actions

extension PaymentViewController {
    @objc func sendButtonPressed() {
        self.paymentViewModel?.sendOrder(paymentSelected:  self.paymentSelected)
    }
    internal func didGoToMenuScreen() {
        coordinator?.moveTo(flow: .home(.homeScreen), data: [])
    }
}

// MARK: - PaymentMethodTableViewCellDelegate

extension PaymentViewController: PaymentMethodTableViewCellDelegate {
    func getPaymentSelected(id: String) {
        self.paymentSelected = id
    }
}

// MARK: - DeliveryLocationTableViewCellDelegate

extension PaymentViewController: DeliveryLocationTableViewCellDelegate {
    func goToDeliveryLocationScreen() {
        let previousScreen = HomeScreen.paymentScreen
        coordinator?.moveTo(flow: .home(.deliveryLocationScreen), data: previousScreen)
    }
}
