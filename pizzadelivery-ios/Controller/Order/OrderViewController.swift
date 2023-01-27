//
//  OrderViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import UIKit

class OrderViewController: UIViewController, OrderBaseCoordinated {
    
    // MARK: - View Models
    
    private var orderListViewModel = OrderListViewModel()
    
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
        self.spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchAllOrders()
        self.setupTableView()
        self.spinner.stopAnimating()
    }
    
    // MARK: - Initialization
    
    required init(coordinator: OrderBaseCoordinator) {
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
        self.tableView.rowHeight = 140.0
        self.tableView.backgroundColor = .white
        self.tableView.backgroundView = self.noDataLabel
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "cell")
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

extension OrderViewController: ViewConfiguration {
    func setupConstraints() {
        self.setupLogoViewConstraints()
        self.setupTableViewConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(self.logoView)
        view.addSubview(self.tableView)
        view.addSubview(self.spinner)
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

extension OrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.orderListViewModel.numberOfSections == 1 {
            return "Pedidos realizados"
        } else {
           return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.orderListViewModel.numberOfSections == 0 {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            noDataLabel.font = UIFont(name: "avenir", size: 16)
            noDataLabel.text = "Faça o seu primeiro pedido :)"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
        }
        return self.orderListViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        
        let orderVM = self.orderListViewModel.orderAtIndex(indexPath.row)
        let itemsOrderVM = self.fetchAllItems(orderViewModel: orderVM!)
        
        cell.configureWithText(orderVM: orderVM!, itemOrderListVM: itemsOrderVM!)
        return cell
    }
}

// MARK: - CoreData

extension OrderViewController {
    private func fetchAllItems(orderViewModel: OrderViewModel) -> ItemOrderListViewModel? {
        let itemOrderListViewModel = ItemOrderListViewModel()
        itemOrderListViewModel.fetchAll(orderViewModel: orderViewModel)
        return itemOrderListViewModel
    }
    
    private func fetchAllOrders() {
        self.orderListViewModel.fetchAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
