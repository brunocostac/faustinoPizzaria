//
//  PaymentViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 17/01/22.
//

import UIKit

class PaymentViewController: UIViewController, MenuBaseCoordinated {
    
    // MARK: - ViewModels
    
    private var orderViewModel: OrderViewModel?
    private var itemOrderListViewModel: ItemOrderListViewModel?
    
    // MARK: - Variables
    
    private var paymentSelected: String?
    
    // MARK: - Views
    
    var coordinator: MenuBaseCoordinator?
    private let logoView = LogoView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let tableHeaderView = HeaderView()
    private let tableFooterView = FooterView()
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.tintColor = .black
        spinner.style = .large
        return spinner
    }()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrder()
        fetchItems()
        configureTableView()
        spinner.stopAnimating()
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
        tableView.tableFooterView = tableFooterView
        tableView.backgroundColor = .white
        tableView.register(PaymentMethodTableViewCell.self, forCellReuseIdentifier: "PaymentMethodTableViewCell")
        tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: "CartItemTableViewCell")
        tableView.register(TotalPriceTableViewCell.self, forCellReuseIdentifier: "TotalPriceTableViewCell")
        tableView.register(DeliveryLocationTableViewCell.self, forCellReuseIdentifier: "DeliveryLocationTableViewCell")
    }
    
    private func displayAlert(title: String, message: String, actionClosure: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction!) in actionClosure()}))
        
        self.present(alertController, animated: true)
    }
    
    private func addressIsValid() -> Bool {
        if orderViewModel?.order.address == nil && orderViewModel?.order.customerName == nil && orderViewModel?.order.neighborhood == nil {
            return false
        } else {
            return true
        }
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
    
    private func setupSpinnerConstraints() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - ViewConfiguration

extension PaymentViewController: ViewConfiguration {
    func setupConstraints() {
        setupLogoConstraints()
        setupTableViewConstraints()
        setupSpinnerConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(logoView)
        view.addSubview(tableView)
        view.addSubview(spinner)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        tableFooterView.footerButton.setTitle("Enviar o pedido", for: .normal)
        tableFooterView.footerButton.addTarget(self, action: #selector(sendOrder), for: .touchUpInside)
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            return nil
        case 2:
            return tableFooterView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            return 60
        default:
            return 0
        }
    }
}

// MARK: - UITableViewDataSource
extension PaymentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Forma de pagamento na entrega"
        case 1:
            return "Resumo do Pedido"
        case 2:
            return "Entregar em"
        default:
            return nil
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
            return cell0
        case 1:
            if itemOrderListViewModel?.count ?? 0 >= indexPath.row + 1 {
                guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "CartItemTableViewCell", for: indexPath) as? CartItemTableViewCell else {
                    return UITableViewCell()
                }
                
                let itemInCart = itemOrderListViewModel?.itemOrderAtIndex(indexPath.row)
                cell1.configureWithText(itemDescription: itemInCart!.itemDescription, itemTotal: itemInCart!.itemTotal)
                
                return cell1
            } else {
                guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "TotalPriceTableViewCell", for: indexPath) as? TotalPriceTableViewCell else {
                    return UITableViewCell()
                }
                cell2.configureWithText(subTotalOrder: itemOrderListViewModel!.totalOrder, totalOrder: itemOrderListViewModel!.totalOrder, fee: "0.00")
                return cell2
            }
        case 2:
            guard let cell3 = tableView.dequeueReusableCell(withIdentifier:
            "DeliveryLocationTableViewCell", for: indexPath) as? DeliveryLocationTableViewCell else {
                return UITableViewCell()
            }
            cell3.delegate = self
            cell3.configureWithText(address: orderViewModel?.order.address ?? "Não existe endereço cadastrado")
            
            return cell3
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - CoreData

extension PaymentViewController {
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
    
    private func saveOrder() {
        CoreDataHelper().updateOrder(orderViewModel: orderViewModel, completion: { success in
            if success {
                self.displayAlert(title: "Sucesso", message: "Pedido recebido, já começaremos a preparar", actionClosure: { [self] in
                    goToMenuScreen()
                })
            }
        })
    }
}

// MARK: - User Actions

extension PaymentViewController {
    @objc func sendOrder() {
        let addressIsValid = addressIsValid()
        
        if addressIsValid {
            if let itemListOrderVM = itemOrderListViewModel {
                orderViewModel?.order.total = Double(itemListOrderVM.totalOrder)!
                orderViewModel?.order.dateWasRequest = Date()
                orderViewModel?.order.dateCompletion = Date(timeInterval: 60*5, since: Date())
                orderViewModel?.order.subTotal = Double(itemListOrderVM.totalOrder)!
                orderViewModel?.order.isOpen = false
                orderViewModel?.order.paymentMethod = paymentSelected
            }
            MockApiClient().sendOrder { [self] response in
                if response {
                    saveOrder()
                }
            }
        } else {
            self.displayAlert(title: "Informação", message: "Por favor, informe o endereço de entrega.", actionClosure: {
                
            })
        }
    }
    
    private func goToMenuScreen() {
        coordinator?.moveTo(flow: .menu(.menuScreen), data: [])
    }
}

// MARK: - PaymentMethodTableViewCellDelegate

extension PaymentViewController: PaymentMethodTableViewCellDelegate {
    func getPaymentSelected(id: String) {
        paymentSelected = id
    }
}

// MARK: - DeliveryLocationTableViewCellDelegate

extension PaymentViewController: DeliveryLocationTableViewCellDelegate {
    func goToDeliveryLocationScreen() {
        let previousScreen = MenuScreen.paymentScreen
        coordinator?.moveTo(flow: .menu(.deliveryLocationScreen), data: previousScreen)
    }
}
