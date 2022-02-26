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
        spinner.startAnimating()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        clearViewModels()
        fetchMenu()
        fetchOrder()
        fetchItems()
        loadCartButton()
        configureTableView()
        spinner.stopAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        myCartButton.isHidden = true
    }
    // MARK: - Initialization
    
    required init(coordinator: MenuBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func clearViewModels() {
        itemOrderListViewModel = nil
        orderViewModel = nil
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
        myCartButton.isHidden = true
        if let items = itemOrderListViewModel {
            myCartButton.configureWithText(quantity: items.quantity, totalPrice: items.totalOrder)
            myCartButton.isHidden = false
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = tableHeaderView
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
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
    
    private func setupMyCartButtonConstraints() {
        myCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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

extension MenuViewController: ViewConfiguration {
    func setupConstraints() {
        setupLogoViewConstraints()
        setupTableViewConstraints()
        setupMyCartButtonConstraints()
        setupSpinnerConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(logoView)
        view.addSubview(tableView)
        view.addSubview(myCartButton)
        view.addSubview(spinner)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        myCartButton.addTarget(self, action: #selector(goToCartScreen), for: .touchUpInside)
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
        goToDishDetailsScreen(item: itemMenuVM)
        tableView.deselectRow(at: indexPath, animated: false)
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
            return menuListViewModel.numberOfRowsInSection(section)
        case 1:
            return menuListViewModel.numberOfRowsInSection(section)
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
        CoreDataHelper().fetchCurrentOrder { currentOrder in
            if let currentOrder = currentOrder {
                self.orderViewModel = OrderViewModel(currentOrder)
            }
        }
    }
    private func fetchItems() {
        if orderViewModel != nil {
            itemOrderListViewModel = CoreDataHelper().fetchItemsCurrentOrder(orderViewModel: orderViewModel)
        }
    }
    
    private func createOrder() {
        if orderViewModel == nil {
            CoreDataHelper().createOrder()
        }
    }
}

// MARK: - User Actions

extension MenuViewController {
    private func goToDishDetailsScreen(item: ItemMenuViewModel) {
        createOrder()
        coordinator?.moveTo(flow: .menu(.dishDetailsScreen), data: item)
    }
    
    @objc func goToCartScreen() {
        coordinator?.moveTo(flow: .menu(.cartScreen), data: [])
    }
}
