//
//  PaymentViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 17/01/22.
//

import UIKit

class PaymentViewController: UIViewController, MenuBaseCoordinated {
    
    // MARK: - ViewModel
    var orderViewModel: OrderViewModel?
    var itemOrderListViewModel: ItemOrderListViewModel?
    
    // MARK: - Views
    
    var coordinator: MenuBaseCoordinator?
    
    private let logoView = LogoView()
    
    private let tableHeaderView = HeaderView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    // MARK: - ViewModel
    let items = ["1 Magueritta 30 CM", "10 Cerveja Império", "1 Mussarela 30CM"]
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViewModels()
        setupViewConfiguration()
    }
    
    required init(coordinator: MenuBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeViewModels() {
        let currentOrder = CoreDataHelper().fetchCurrentOrder()
        if currentOrder == nil {
            CoreDataHelper().createOrder()
        } else {
            orderViewModel = currentOrder
            itemOrderListViewModel = CoreDataHelper().fetchItemsCurrentOrder(orderViewModel: orderViewModel)
        }
    }
    
    // MARK: - Functions
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = tableHeaderView
        tableView.register(PaymentMethodTableViewCell.self, forCellReuseIdentifier: "PaymentMethodTableViewCell")
        tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: "CartItemTableViewCell")
        tableView.register(TotalPriceTableViewCell.self, forCellReuseIdentifier: "TotalPriceTableViewCell")
        tableView.register(DeliveryLocationTableViewCell.self, forCellReuseIdentifier: "DeliveryLocationTableViewCell")
    }

    // MARK: - Setup Constraints
    
    func setupLogoConstraints() {
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

extension PaymentViewController: ViewConfiguration {
    func setupConstraints() {
        setupLogoConstraints()
        setupTableViewConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(logoView)
        view.addSubview(tableView)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        configureTableView()
        title = "Pagamento"
    }
}

// MARK: - UITableViewDelegate
extension PaymentViewController: UITableViewDelegate {
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
extension PaymentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Forma de pagamento na entrega"
        } else if  section == 1 {
            return "Resumo do Pedido"
        } else {
            return "Entregar em"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1:
            return itemOrderListViewModel!.count + 1 ?? 0
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let c0 = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as? PaymentMethodTableViewCell else {
                return UITableViewCell()
            }
            c0.selectionStyle = .none
            return c0
        case 1:
            if itemOrderListViewModel?.count ?? 0 >= indexPath.row + 1 {
                guard let c1 = tableView.dequeueReusableCell(withIdentifier: "CartItemTableViewCell", for: indexPath) as? CartItemTableViewCell else {
                    return UITableViewCell()
                }
                c1.selectionStyle = .none
                let itemInCart = itemOrderListViewModel?.itemOrderViewModel[indexPath.row]
                c1.itemNameLabel.text = "\(String(describing: itemInCart!.quantity)) \(itemInCart!.name)"
                c1.itemTotalLabel.text = "R$ \(String(describing: itemInCart!.price)) "
                
                return c1
            } else {
                guard let c2 = tableView.dequeueReusableCell(withIdentifier: "TotalPriceTableViewCell", for: indexPath) as? TotalPriceTableViewCell else {
                    return UITableViewCell()
                }
                c2.selectionStyle = .none
                c2.subTotalLabel.text = "Subtotal:"
                c2.subTotalValueLabel.text = "R$ \(itemOrderListViewModel!.totalPrice)"
                c2.feeLabel.text = "Taxa de entrega:"
                c2.feeValueLabel.text =  "R$ 0.00"
                c2.totalLabel.text = "Total:"
                c2.totalValueLabel.text = "R$ \(itemOrderListViewModel!.totalPrice)"
                return c2
            }
        case 2:
            guard let c3 = tableView.dequeueReusableCell(withIdentifier: "DeliveryLocationTableViewCell", for: indexPath) as? DeliveryLocationTableViewCell else {
                return UITableViewCell()
            }
            c3.selectionStyle = .none
            c3.placeDescriptionLabel.text = "Estrada dos Tres Rios 9000 - apt 908 - bl 2"
            c3.goToPaymentButton.setTitle("Concluir o pedido", for: .normal)
            return c3
        default:
            return UITableViewCell()
        }
    }
}
