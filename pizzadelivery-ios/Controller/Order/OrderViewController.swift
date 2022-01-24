//
//  OrderViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import UIKit

class OrderViewController: UIViewController, OrderBaseCoordinated {
    
    // MARK: - View Models
    var orders = [Order]()
    
    // MARK: - Views
    
    var coordinator: OrderBaseCoordinator?
    
    private let logoView = LogoView()
    
    private let tableHeaderView = HeaderView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfiguration()
        initializeOrders()
    }
    
    // MARK: - Initialization
    
    required init(coordinator: OrderBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func initializeOrders() {
        orders.append(Order(items:
        [ItemOrder(name: "Magueritta 30cm",
            itemId: "32",
            quantity: 1,
            price: 35.95,
            comment:"A"),
         ItemOrder(name: "Calabresa 30cm",
             itemId: "34",
             quantity: 2,
             price: 31.95,
             comment: "B")],
         address: "Estrada dos Tres Rios 9000 - apt 908 - bl 2",
         status: "Finalizado",
         subTotal: 67.95, total: 71.95, paymentMethod: "dinheiro",
         orderId: 32, customerName: "Bruno", dateWasRequest: "21/01/2022 ás 17:33",
         dateCompletion: "21/01/2022 ás 18:32"))
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = tableHeaderView
        tableView.rowHeight = 100.0
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "cell")
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

extension OrderViewController: ViewConfiguration {
    
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
        title = "Pedidos"
        configureTableView()
    }
}

// MARK: - UITableViewDelegate

extension OrderViewController: UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension OrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pedidos Realizados"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = "\(orders[indexPath.row].status) - Entregue às \(orders[indexPath.row].dateCompletion)"
        cell.descriptionLabel.text = "\(orders[indexPath.row].items[indexPath.row].quantity) \(orders[indexPath.row].items[indexPath.row].name)"
        cell.priceLabel.text = "R$ \(orders[indexPath.row].total)"
        return cell
    }
}
