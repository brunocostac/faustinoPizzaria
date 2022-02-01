//
//  MenuViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import UIKit

class MenuViewController: UIViewController, MenuBaseCoordinated {
    
    // MARK: - ViewModel
    var menuListViewModel = MenuListViewModel()
   
    // MARK: - Views
    
    var coordinator: MenuBaseCoordinator?
    
    private let logoView = LogoView()
    
    private let tableHeaderView = HeaderView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    private let myCartButton = MyCartButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateMenu()
        setupViewConfiguration()
    }
    
    // MARK: - Initialization
    
    required init(coordinator: MenuBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func populateMenu() {
        MockApiClient().fetchMenu { [self] (_, menuData) in
            self.menuListViewModel.menuViewModel = menuData.map(MenuViewModel.init)
            self.tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = tableHeaderView
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func goToCartScreen() {
        let date = Date()
        coordinator?.moveTo(flow: .menu(.cartScreen), data: date)
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
}

// MARK: - ViewConfiguration

extension MenuViewController: ViewConfiguration {
    func setupConstraints() {
        setupLogoViewConstraints()
        setupTableViewConstraints()
        setupMyCartButtonConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(logoView)
        view.addSubview(tableView)
        view.addSubview(myCartButton)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        configureTableView()
        myCartButton.isHidden = true
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
        let viewModel = self.menuListViewModel.menuViewModel(at: indexPath.section)
        tableView.deselectRow(at: indexPath, animated: false)
        coordinator?.moveTo(flow: .menu(.dishDetailsScreen), data: viewModel.items[indexPath.row])
    }
}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let viewModel = self.menuListViewModel.menuViewModel(at: section)
        
        switch section {
        case 0:
            return viewModel.category
        case 1:
            return viewModel.category
        default:
            return "Não existem categorias cadastradas"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuListViewModel.menuViewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let viewModel = self.menuListViewModel.menuViewModel(at: section)
        
        switch section {
        case 0:
            return viewModel.items.count
        case 1:
            return viewModel.items.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MenuTableViewCell else {
            return UITableViewCell()
        }
        
        let viewModel = self.menuListViewModel.menuViewModel(at: indexPath.section)
        
        cell.titleLabel.text = viewModel.items[indexPath.row].name
        cell.dishImage.image = UIImage(named: viewModel.items[indexPath.row].imageUrl)
        cell.descriptionLabel.text = viewModel.items[indexPath.row].description
        cell.priceLabel.text = "por R$ \(viewModel.items[indexPath.row].price)"
        return cell
    }
}
