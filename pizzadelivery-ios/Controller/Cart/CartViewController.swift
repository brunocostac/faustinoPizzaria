//
//  CartViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 12/01/22.
//

import UIKit

class CartViewController: UIViewController, MenuBaseCoordinated {
    
    // MARK: - Views
    
    var coordinator: MenuBaseCoordinator?
    
    private let logoView = LogoView()
    
    private let tableHeaderView = HeaderView()
    
    private let tableView = UITableView()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init(coordinator: MenuBaseCoordinator) {
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
        tableView.tableHeaderView = tableHeaderView
        tableView.register(TotalPriceTableViewCell.self, forCellReuseIdentifier: "TotalPriceTableViewCell")
        tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: "CartItemTableViewCell")
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
    
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*if !self.itemsInCart.isEmpty {
            if (self.itemsInCart.count) >= indexPath.row + 1 {
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "TableViewCell1", for: indexPath) as! CartItemTableViewCell
                cell1.selectionStyle = .none
                let itemInCart = self.itemsInCart[indexPath.row]
                cell1.itemName_Label.text = itemInCart.name
                cell1.itemPrice_Label.text = "\(itemInCart.price)" + " " + itemInCart.currency
                cell1.itemImage_ImageView.sd_setImage(with: URL(string: itemInCart.imageUrl), placeholderImage: UIImage(named: "placeholder"))
                cell1.cancelItem_Button.tag = indexPath.row
                cell1.cancelItem_Button.addTarget(self, action: #selector(cancelItem), for: .touchUpInside)
                return cell1
            }else {
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TotalPriceTableViewCell
                cell2.selectionStyle = .none
                cell2.delivery_Label.text = "Delivery is free"
                cell2.value_Label.text = "Value:"
                cell2.totalPrice_Label.text = self.totalPrice
                return cell2
            }
        }*/
        return UITableViewCell()
    }
}
