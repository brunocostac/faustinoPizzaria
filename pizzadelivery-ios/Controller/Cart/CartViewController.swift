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
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrder()
        fetchItems()
        configureTableView()
    }
    
    required init(coordinator: MenuBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = tableFooterView
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
        tableFooterView.footerButton.addTarget(self, action: #selector(goToPaymentScreen), for: .touchUpInside)
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
            return tableFooterView
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
            return itemOrderListViewModel!.count + 1
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
                let itemInCart = itemOrderListViewModel?.itemOrderAtIndex(indexPath.row)
                
                guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "CartItemTableViewCell", for: indexPath) as? CartItemTableViewCell else {
                    return UITableViewCell()
                }
                
                cell1.configureWithText(itemDescription: itemInCart!.itemDescription, itemTotal: itemInCart!.itemTotal)
                
                return cell1
            } else {
                guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "TotalPriceTableViewCell", for: indexPath) as? TotalPriceTableViewCell else {
                    return UITableViewCell()
                }
                
                cell2.configureWithText(subTotalOrder: itemOrderListViewModel!.totalOrder, totalOrder: itemOrderListViewModel!.totalOrder, fee: "0.00")
               
                return cell2
            }
        case 1:
            guard let cell3 = tableView.dequeueReusableCell(withIdentifier: "DeliveryLocationTableViewCell", for: indexPath) as? DeliveryLocationTableViewCell else {
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
        CoreDataHelper().fetchCurrentOrder { currentOrder in
            if let currentOrder = currentOrder {
                self.orderViewModel = OrderViewModel(currentOrder)
            }
        }
    }
    
    func fetchItems() {
        if orderViewModel != nil {
            if let items = CoreDataHelper().fetchItemsCurrentOrder(orderViewModel: orderViewModel) {
                itemOrderListViewModel = items
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - User Actions

extension CartViewController {
    @objc func goToPaymentScreen() {
        coordinator?.moveTo(flow: .menu(.paymentScreen), data: [])
    }
}

// MARK: - DeliveryLocationTableViewCellDelegate

extension CartViewController: DeliveryLocationTableViewCellDelegate {
    func goToDeliveryLocationScreen() {
        coordinator?.moveTo(flow: .menu(.deliveryLocationScreen), data: [])
    }
}
