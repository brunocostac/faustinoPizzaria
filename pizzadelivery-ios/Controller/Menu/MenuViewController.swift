//
//  MenuViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 06/01/22.
//

import UIKit

class MenuViewController: UIViewController, MenuBaseCoordinated {
    
    // MARK: - ViewModel
    var menu = [Menu]()
   
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
        initializeMenu()
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
    
    private func initializeMenu() {
        menu.append(
        Menu(category: "Tradicionais napoletanas", items: [
            ItemMenu(name: "Magueritta 30cm", imageUrl: "pizza3", description: "Molho de tomate italiano, mozzarella de bufala, manjericão fresco e tomates cerejas", price: 35.95),
            ItemMenu(name: "Calabresa 30cm", imageUrl: "pizza3", description: "Molho de tomate italiano, mozzarella, calabresa e orégano", price: 34.95),
            ItemMenu(name: "Quatro queijos 30cm", imageUrl: "pizza3", description: "Molho de tomate italiano, mozzarella, gorgonzola, provolone, parmesão e orégano", price: 36.95)
        ]))
        
        menu.append(
        Menu(category: "Tradicionais brasileiras", items: [
        ItemMenu(name: "Calabresa e cebola 30cm", imageUrl: "pizza3", description: "Molho de tomate italiano, mozzarella, calabresa, cebola e orégano", price: 31.95),
        ItemMenu(name: "Brasileira 30cm", imageUrl: "pizza3", description: "Molho de tomate italiano, mozzarella, calabresa, cebola, ovos e orégano", price: 33.95),
        ItemMenu(name: "Veneza 30cm", imageUrl: "pizza3", description: "Molho de tomate italiano, presunto, champignon orégano", price: 34.95)
        ])) 
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = tableHeaderView
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func goToCartScreen() {
        coordinator?.moveTo(flow: .menu(.cartScreen), userData: nil)
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
        tableView.deselectRow(at: indexPath, animated: false)
        coordinator?.moveTo(flow: .menu(.dishDetailsScreen), userData: ["title": "Detalhes"])
    }
}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return menu[section].category
        case 1:
            return menu[section].category
        default:
            return "Não existem categorias cadastradas"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return menu[section].items.count
        case 1:
            return menu[section].items.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MenuTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = menu[indexPath.section].items[indexPath.row].name
        cell.dishImage.image = UIImage(named: menu[indexPath.section].items[indexPath.row].imageUrl)
        cell.descriptionLabel.text = menu[indexPath.section].items[indexPath.row].description
        cell.priceLabel.text = "por R$ \(menu[indexPath.section].items[indexPath.row].price)"
        return cell
    }
}
