//
//  CartViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 12/01/22.
//

import UIKit

class CartViewController: UIViewController, MenuBaseCoordinated {
    
    // MARK: - ViewModel
    
    private var orderViewModel: OrderViewModel?
    private var itemOrderListViewModel: ItemOrderListViewModel?
    
    // MARK: - Views
    
    var coordinator: MenuBaseCoordinator?
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
        self.fetchOrder()
        self.fetchItems()
        self.setupTableView()
        self.spinner.stopAnimating()
    }
    
    required init(coordinator: MenuBaseCoordinator) {
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
        self.tableView.tableHeaderView = tableHeaderView
        self.tableView.tableFooterView = tableFooterView
        self.tableView.backgroundColor = .white
        self.tableView.register(TotalPriceTableViewCell.self, forCellReuseIdentifier: "TotalPriceTableViewCell")
        self.tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: "CartItemTableViewCell")
        self.tableView.register(DeliveryLocationTableViewCell.self, forCellReuseIdentifier: "DeliveryLocationTableViewCell")
    }
    
    // MARK: - Setup Constraints
    
    private func setupLogoViewConstraints() {
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

extension CartViewController: ViewConfiguration {
    func setupConstraints() {
        self.setupLogoViewConstraints()
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
        self.tableFooterView.footerButton.addTarget(self, action: #selector(self.goToPaymentScreen), for: .touchUpInside)
    }
}

// MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {
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
            return UIView()
        case 1:
            return self.tableFooterView
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 60
        default:
            return 0
        }
    }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Resumo do Pedido"
        } else {
            return "Local de entrega"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.itemOrderListViewModel!.count + 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if self.itemOrderListViewModel?.count ?? 0 >= indexPath.row + 1 {
                let itemInCart = self.itemOrderListViewModel?.itemOrderAtIndex(indexPath.row)
                
                guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "CartItemTableViewCell", for: indexPath) as? CartItemTableViewCell else {
                    return UITableViewCell()
                }
                
                cell1.configureWithText(itemDescription: itemInCart!.itemDescription, itemTotal: itemInCart!.itemTotal)
                
                return cell1
            } else {
                guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "TotalPriceTableViewCell", for: indexPath) as? TotalPriceTableViewCell else {
                    return UITableViewCell()
                }
                
                cell2.configureWithText(subTotalOrder: self.itemOrderListViewModel!.totalOrder, totalOrder: self.itemOrderListViewModel!.totalOrder, fee: "0.00")
               
                return cell2
            }
        case 1:
            guard let cell3 = tableView.dequeueReusableCell(
            withIdentifier: "DeliveryLocationTableViewCell", for: indexPath) as? DeliveryLocationTableViewCell else {
                return UITableViewCell()
            }
            cell3.delegate = self
            cell3.configureWithText(address: orderViewModel?.order.address ?? "Não existe endereço cadastrado")
            
            return cell3
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - CoreData

extension CartViewController {
    func fetchOrder() {
        OrderRepository().fetch { currentOrder in
            if let currentOrder = currentOrder {
                self.orderViewModel = OrderViewModel(currentOrder)
            }
        }
    }
    
    private func fetchItems() {
        if self.orderViewModel != nil {
            self.itemOrderListViewModel = ItemOrderRepository().fetchAll(orderViewModel: self.orderViewModel)
        }
    }
}

// MARK: - User Actions

extension CartViewController {
    @objc func goToPaymentScreen() {
        self.coordinator?.moveTo(flow: .menu(.paymentScreen), data: [])
    }
}

// MARK: - DeliveryLocationTableViewCellDelegate

extension CartViewController: DeliveryLocationTableViewCellDelegate {
    func goToDeliveryLocationScreen() {
        let previousScreen = MenuScreen.cartScreen
        self.coordinator?.moveTo(flow: .menu(.deliveryLocationScreen), data: previousScreen)
    }
}
