//
//  OrderViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import UIKit

class OrderViewController: UIViewController, OrderBaseCoordinated {
    
    // MARK: - View Models
    
    private var orderListViewModel: OrderListViewModel?
    
    // MARK: - Views
    
    var coordinator: OrderBaseCoordinator?
    private let logoView = LogoView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let tableHeaderView = HeaderView()
    private let noDataLabel = UILabel()
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.tintColor = .black
        spinner.style = .large
        return spinner
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrders()
        configureTableView()
        spinner.stopAnimating()
    }
    
    // MARK: - Initialization
    
    required init(coordinator: OrderBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100.0
        tableView.backgroundView = noDataLabel
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
            tableView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: logoView.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupSpinnerConstraints() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
        view.addSubview(spinner)
    }
    
    func configureViews() {
        view.backgroundColor = .white
    }
}

// MARK: - UITableViewDelegate

extension OrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension OrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if orderListViewModel?.numberOfSections == 1 {
            return "Pedidos realizados"
        } else {
           return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if orderListViewModel!.numberOfSections == 0 {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            noDataLabel.font = UIFont(name: "avenir", size: 16)
            noDataLabel.text = "Faça o seu primeiro pedido :)"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
        }
        return orderListViewModel!.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderListViewModel?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        let orderVM = orderListViewModel?.orderAtIndex(indexPath.row)
        let itemsOrderVM = CoreDataHelper().fetchItemsCurrentOrder(orderViewModel: orderVM)
        
        cell.configureWithText(orderVM: orderVM!, itemOrderListVM: itemsOrderVM!)
        return cell
    }
}

// MARK: - CoreData

extension OrderViewController {
    private func fetchOrders() {
        CoreDataHelper().fetchOrders { orders in
            var orderVM = [OrderViewModel]()
            if let orders = orders {
                for order in orders {
                    let viewModel = OrderViewModel(order: order)
                    orderVM.append(viewModel)
                }
                self.orderListViewModel = OrderListViewModel(orders: orderVM)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
