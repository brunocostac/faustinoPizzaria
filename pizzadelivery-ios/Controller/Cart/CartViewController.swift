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
    private let tableHeaderView = HeaderView()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrder()
        configureTableView()
    }
    
    required init(coordinator: MenuBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchOrder() {
        CoreDataHelper().fetchCurrentOrder { currentOrder in
            if let currentOrder = currentOrder {
                self.orderViewModel = OrderViewModel(currentOrder)
                self.fetchItems(self.orderViewModel!)
            }
        }
    }
    
    func fetchItems(_ orderViewModel: OrderViewModel) {
        if let items = CoreDataHelper().fetchItemsCurrentOrder(orderViewModel: orderViewModel) {
            itemOrderListViewModel = items
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
            return itemOrderListViewModel!.count + 1  ?? 0
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
                guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "CartItemTableViewCell", for: indexPath) as? CartItemTableViewCell else {
                    return UITableViewCell()
                }
                cell1.selectionStyle = .none
                let itemInCart = itemOrderListViewModel?.itemOrderViewModel[indexPath.row]
                cell1.itemNameLabel.text = "\(String(describing: itemInCart!.quantity)) \(itemInCart!.name)"
                cell1.itemTotalLabel.text = "R$ \(String(describing: itemInCart!.price)) "
                
                return cell1
            } else {
                guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "TotalPriceTableViewCell", for: indexPath) as? TotalPriceTableViewCell else {
                    return UITableViewCell()
                }
                cell2.selectionStyle = .none
                cell2.subTotalLabel.text = "Subtotal:"
                cell2.subTotalValueLabel.text = "R$ \(itemOrderListViewModel!.total)"
                cell2.feeLabel.text = "Taxa de entrega:"
                cell2.feeValueLabel.text =  "R$ 0.00"
                cell2.totalLabel.text = "Total:"
                cell2.totalValueLabel.text = "R$ \(itemOrderListViewModel!.total)"
                return cell2
            }
        case 1:
            guard let cell3 = tableView.dequeueReusableCell(withIdentifier: "DeliveryLocationTableViewCell", for: indexPath) as? DeliveryLocationTableViewCell else {
                return UITableViewCell()
            }
            
            if let address = orderViewModel?.order.address {
                cell3.placeDescriptionLabel.text = "\(address)"
            } else {
                cell3.placeDescriptionLabel.text = "Não existe um endereço cadastrado"
            }
            cell3.selectionStyle = .none
            cell3.delegate = self
            return cell3
        default:
            return UITableViewCell()
        }
    }
}

extension CartViewController: DeliveryLocationTableViewCellDelegate {
    func goToNextScreen() {
        coordinator?.moveTo(flow: .menu(.paymentScreen), data: [])
    }
    
    func goToDeliveryLocationScreen() {
        coordinator?.moveTo(flow: .menu(.deliveryLocationScreen), data: [])
    }
}
