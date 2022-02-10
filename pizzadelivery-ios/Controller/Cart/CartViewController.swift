//
//  CartViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 12/01/22.
//

import UIKit

class CartViewController: UIViewController, MenuBaseCoordinated {
    
    // MARK: - ViewModel
    var orderViewModel: OrderViewModel?
    var itemOrderListViewModel: ItemOrderListViewModel?
    
    // MARK: - Views
    var coordinator: MenuBaseCoordinator?
    
    private let logoView = LogoView()
    private let tableHeaderView = HeaderView()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViewModels()
        setupViewConfiguration()
    }

    required init(coordinator: MenuBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeViewModels() {
        let currentOrder = CoreDataHelper().fetchCurrentOrder()
        if currentOrder == nil {
            CoreDataHelper().createOrder()
        } else {
            orderViewModel = currentOrder
            itemOrderListViewModel = CoreDataHelper().fetchItemsCurrentOrder(orderViewModel: orderViewModel)
        }
    }
    
    // MARK: - Functions
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = tableHeaderView
        tableView.register(TotalPriceTableViewCell.self, forCellReuseIdentifier: "TotalPriceTableViewCell")
        tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: "CartItemTableViewCell")
        tableView.register(DeliveryLocationTableViewCell.self, forCellReuseIdentifier: "DeliveryLocationTableViewCell")
    }
    
    // MARK: - Setup Constraints
    
    private func setupLogoViewConstraints() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            logoView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: logoView.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

// MARK: - ViewConfiguration

extension CartViewController: ViewConfiguration {
    func setupConstraints() {
        setupLogoViewConstraints()
        setupTableViewConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(logoView)
        view.addSubview(tableView)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        configureTableView()
        title = "Carrinho"
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
            return itemOrderListViewModel!.count + 1 ?? 0
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if itemOrderListViewModel?.count ?? 0 >= indexPath.row + 1 {
                guard let c1 = tableView.dequeueReusableCell(withIdentifier: "CartItemTableViewCell", for: indexPath) as? CartItemTableViewCell else {
                    return UITableViewCell()
                }
                c1.selectionStyle = .none
                let itemInCart = itemOrderListViewModel?.itemOrderViewModel[indexPath.row]
                c1.itemNameLabel.text = "\(String(describing: itemInCart!.quantity)) \(itemInCart!.name)"
                c1.itemTotalLabel.text = "R$ \(String(describing: itemInCart!.price)) "
                
                return c1
            } else {
                guard let c2 = tableView.dequeueReusableCell(withIdentifier: "TotalPriceTableViewCell", for: indexPath) as? TotalPriceTableViewCell else {
                    return UITableViewCell()
                }
                c2.selectionStyle = .none
                c2.subTotalLabel.text = "Subtotal:"
                c2.subTotalValueLabel.text = "R$ \(itemOrderListViewModel!.totalPrice)"
                c2.feeLabel.text = "Taxa de entrega:"
                c2.feeValueLabel.text =  "R$ 0.00"
                c2.totalLabel.text = "Total:"
                c2.totalValueLabel.text = "R$ \(itemOrderListViewModel!.totalPrice)"
                return c2
            }
        case 1:
            guard let c3 = tableView.dequeueReusableCell(withIdentifier: "DeliveryLocationTableViewCell", for: indexPath) as? DeliveryLocationTableViewCell else {
                return UITableViewCell()
            }
            c3.selectionStyle = .none
            c3.placeDescriptionLabel.text = "Estrada dos Tres Rios 9000 - apt 908 - bl 2"
            c3.delegate = self
            return c3
        default:
            return UITableViewCell()
        }
    }
}

extension CartViewController: DeliveryLocationTableViewCellDelegate {
    func goToPaymentScreen() {
        let date = Date()
        coordinator?.moveTo(flow: .menu(.paymentScreen), data: date)
    }
    
    func goToDeliveryLocationScreen() {
        let date = Date()
        coordinator?.moveTo(flow: .menu(.deliveryLocationScreen), data: date)
    }
}
