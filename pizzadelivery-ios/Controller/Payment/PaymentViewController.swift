//
//  PaymentViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 17/01/22.
//

import UIKit

class PaymentViewController: UIViewController, MenuBaseCoordinated {
    
    // MARK: - ViewModels
    var orderViewModel: OrderViewModel?
    var itemOrderListViewModel: ItemOrderListViewModel?
    
    // MARK: - Variables
    var paymentSelected: String?
    
    // MARK: - Views
    
    var coordinator: MenuBaseCoordinator?
    
    private let logoView = LogoView()
    
    private let tableHeaderView = HeaderView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrder()
        configureTableView()
    }
    
    required init(coordinator: MenuBaseCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchOrder() {
        if let currentOrder = CoreDataHelper().fetchCurrentOrder() {
            orderViewModel = currentOrder
            if let itemOrderListVM = CoreDataHelper().fetchItemsCurrentOrder(orderViewModel: orderViewModel) {
                itemOrderListViewModel = itemOrderListVM
            }
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
        tableView.reloadData()
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
        case 0:
            return 1
        case 1:
            return itemOrderListViewModel!.count + 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell0 = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as? PaymentMethodTableViewCell else {
                return UITableViewCell()
            }
            cell0.delegate = self
            cell0.selectionStyle = .none
            return cell0
        case 1:
            if itemOrderListViewModel?.count ?? 0 >= indexPath.row + 1 {
                guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "CartItemTableViewCell", for: indexPath) as? CartItemTableViewCell else {
                    return UITableViewCell()
                }
                cell1.selectionStyle = .none
                let itemInCart = itemOrderListViewModel?.itemOrderViewModel[indexPath.row]
                cell1.itemNameLabel.text = "\(String(describing: itemInCart!.quantity)) \(itemInCart!.name)"
                cell1.itemTotalLabel.text = "R$ \(String(describing: itemInCart!.price)) "
                
                return cell1
            } else {
                guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "TotalPriceTableViewCell", for: indexPath) as? TotalPriceTableViewCell else {
                    return UITableViewCell()
                }
                cell2.selectionStyle = .none
                cell2.subTotalLabel.text = "Subtotal:"
                cell2.subTotalValueLabel.text = "R$ \(itemOrderListViewModel!.total)"
                cell2.feeLabel.text = "Taxa de entrega:"
                cell2.feeValueLabel.text =  "R$ 0.00"
                cell2.totalLabel.text = "Total:"
                cell2.totalValueLabel.text = "R$ \(itemOrderListViewModel!.total)"
                return cell2
            }
        case 2:
            guard let cell3 = tableView.dequeueReusableCell(withIdentifier: "DeliveryLocationTableViewCell", for: indexPath) as? DeliveryLocationTableViewCell else {
                return UITableViewCell()
            }
            if let address = orderViewModel?.order.address {
                cell3.placeDescriptionLabel.text = "\(address)"
            } else {
                cell3.placeDescriptionLabel.text = "Não existe endereço cadastrado"
            }
            cell3.selectionStyle = .none
            cell3.delegate = self
            cell3.goToPaymentButton.setTitle("Concluir o pedido", for: .normal)
            return cell3
        default:
            return UITableViewCell()
        }
    }
}
extension PaymentViewController: DeliveryLocationTableViewCellDelegate {
    func goToNextScreen() {
        if let itemListOrderVM = itemOrderListViewModel {
            orderViewModel?.order.total = Double(itemListOrderVM.total)!
            orderViewModel?.order.dateWasRequest = Date()
            orderViewModel?.order.subTotal = Double(itemListOrderVM.total)!
            orderViewModel?.order.paymentMethod = "1"
            orderViewModel?.order.isOpen = false
            orderViewModel?.order.paymentMethod = paymentSelected
        }
        CoreDataHelper().updateOrder(orderViewModel: orderViewModel)
        goToMenuScreen()
    }
    func goToMenuScreen() {
        coordinator?.moveTo(flow: .menu(.menuScreen), data: [])
    }
    
    func goToDeliveryLocationScreen() {
        coordinator?.moveTo(flow: .menu(.deliveryLocationScreen), data: [])
    }
}

extension PaymentViewController: PaymentMethodTableViewCellDelegate {
    func getPaymentSelected(id: String) {
        paymentSelected = id
    }
}
