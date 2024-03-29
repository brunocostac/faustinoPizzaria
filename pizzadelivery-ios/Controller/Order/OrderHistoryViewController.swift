//
//  OrderViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import UIKit

class OrderHistoryViewController: UIViewController, OrderBaseCoordinated, OrderHistoryViewModelDelegate {
    
    // MARK: - View Models
    private var orderHistoryViewModel = OrderHistoryViewModel()
  
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
        orderHistoryViewModel.viewDidAppear()
        orderHistoryViewModel.delegate = self
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

extension OrderHistoryViewController: ViewConfiguration {
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

extension OrderHistoryViewController: UITableViewDelegate {
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

extension OrderHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.orderHistoryViewModel.orderListViewModel.numberOfSections == 1 {
            return "Pedidos realizados"
        } else {
           return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orderHistoryViewModel.orderListViewModel.numberOfRowsInSection == 0 {
            self.tableView.setEmptyView(title: "Nenhum pedido foi encontrado", message: "", messageImage: UIImage(systemName: "magnifyingglass.circle")!)
        } else {
            self.tableView.backgroundView = nil
        }
        
        return self.orderHistoryViewModel.orderListViewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OrderTableViewCell else {
            return UITableViewCell()
        }
        
        let orderVM =  self.orderHistoryViewModel.orderListViewModel.orderAtIndex(indexPath.row)
        let itemsOrderVM = self.orderHistoryViewModel.fetchAllItems(orderViewModel: orderVM!)
        
        cell.configureWithText(orderVM: orderVM!, itemOrderListVM: itemsOrderVM!)
        return cell
    }
}


extension OrderHistoryViewController {
    internal func didFetchAllOrders() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
