//
//  MenuViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import UIKit

class MenuViewController: UIViewController, MenuBaseCoordinated {
    
    // MARK: - ViewModel
    
    private var menuListViewModel = MenuListViewModel()
    private var orderViewModel: OrderViewModel?
    private var itemOrderListViewModel: ItemOrderListViewModel?
    
    // MARK: - Views
    
    var coordinator: MenuBaseCoordinator?
    private let logoView = LogoView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let tableHeaderView = HeaderView()
    private let myCartButton = MyCartButton()
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
        self.clearViewModels()
        self.fetchMenu()
        self.fetchOrder()
        self.fetchItems()
        self.loadCartButton()
        self.setupTableView()
        self.spinner.stopAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.myCartButton.isHidden = true
    }
    // MARK: - Initialization
    
    required init(coordinator: MenuBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        self.setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func clearViewModels() {
        self.itemOrderListViewModel = nil
        self.orderViewModel = nil
    }
    
    private func fetchMenu() {
        MockApiClient().fetchMenu { (_, menuData) in
            self.menuListViewModel.menuViewModel = menuData.map(MenuViewModel.init)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadCartButton() {
        self.myCartButton.isHidden = true
        if let items = itemOrderListViewModel {
            self.myCartButton.configureWithText(quantity: items.quantity, totalPrice: items.totalOrder)
            self.myCartButton.isHidden = false
        }
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.backgroundColor = .white
        self.tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
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
    
    private func setupMyCartButtonConstraints() {
        self.myCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.myCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.myCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.myCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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

extension MenuViewController: ViewConfiguration {
    func setupConstraints() {
        self.setupLogoViewConstraints()
        self.setupTableViewConstraints()
        self.setupMyCartButtonConstraints()
        self.setupSpinnerConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(self.logoView)
        view.addSubview(self.tableView)
        view.addSubview(self.myCartButton)
        view.addSubview(self.spinner)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        self.myCartButton.addTarget(self, action: #selector(self.goToCartScreen), for: .touchUpInside)
    }
}

// MARK: - UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
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
        let itemMenuVM = self.menuListViewModel.menuViewModel(at: indexPath.section).itemMenuAtIndex(indexPath.row)
        self.goToDishDetailsScreen(item: itemMenuVM)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let menuVM = self.menuListViewModel.menuViewModel(at: section)
        
        switch section {
        case 0:
            return menuVM.category
        case 1:
            return menuVM.category
        default:
            return "Não existem categorias cadastradas"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuListViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.menuListViewModel.numberOfRowsInSection(section)
        case 1:
            return self.menuListViewModel.numberOfRowsInSection(section)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MenuTableViewCell else {
            return UITableViewCell()
        }
        
        let itemMenuVM = self.menuListViewModel.menuViewModel(at: indexPath.section).itemMenuAtIndex(indexPath.row)
        
        cell.configureWith(name: itemMenuVM.name, description: itemMenuVM.description, price: itemMenuVM.price, image: itemMenuVM.image)
        
        return cell
    }
}

// MARK: - CoreData

extension MenuViewController {
    private func fetchOrder() {
        OrderRepository().fetch{ orderVM in
            self.orderViewModel = orderVM
        }
    }
    private func fetchItems() {
        if orderViewModel != nil {
           ItemOrderRepository().fetchAll(orderViewModel: orderViewModel) { itemOrderVM in
               self.itemOrderListViewModel = itemOrderVM
            }
        }
    }
    
    private func createOrder() {
        if orderViewModel == nil {
            OrderRepository().create()
        }
    }
}

// MARK: - User Actions

extension MenuViewController {
    private func goToDishDetailsScreen(item: ItemMenuViewModel) {
        self.createOrder()
        coordinator?.moveTo(flow: .menu(.dishDetailsScreen), data: item)
    }
    
    @objc func goToCartScreen() {
        coordinator?.moveTo(flow: .menu(.cartScreen), data: [])
    }
}
