//
//  MenuDetailsViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 11/01/22.
//

import UIKit

class DishDetailsViewController: UIViewController, MenuBaseCoordinated {
    
    // MARK: - ViewModel
    
    public var itemMenuViewModel: ItemMenuViewModel?
    private var orderViewModel = OrderViewModel()
    private var itemOrderViewModel = ItemOrderViewModel()
    private var itemOrderListViewModel = ItemOrderListViewModel()
    
    // MARK: - Variables
    
    private var flag: ItemOrderStatus?
    
    // MARK: - Views
    
    var coordinator: MenuBaseCoordinator?
    private var dishImageView = DishImageView(frame: .zero)
    private let infoView = DishInfoView()
    private let commentView = DishCommentView()
    private let quantityView = DishQuantityView()
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
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
        self.setupTextField()
        self.setupToHideKeyboardOnTapOnView()
        self.spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchOrder()
        self.fetchItems()
        self.fetchCurrentItem()
        self.setFlag()
        self.configureDishDetails()
        self.configureMyCartButton()
        self.spinner.stopAnimating()
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
    
    private func setupTextField() {
        self.commentView.commentTextField.delegate = self
    }
    
    private func setFlag() {
        self.flag = self.itemOrderViewModel.flag
    }
    
    private func configureDishDetails() {
        if  self.flag == ItemOrderStatus.create || self.flag == ItemOrderStatus.update {
            self.dishImageView.configureWith(url: itemMenuViewModel!.itemMenu.imageUrl)
            self.infoView.configureWith(name: itemMenuViewModel!.itemMenu.name, description: itemMenuViewModel!.itemMenu.description, price: itemMenuViewModel!.itemMenu.price)
            self.quantityView.configureAddToCartButtonWith(flag: flag!, price: String(itemMenuViewModel!.itemMenu.price))
        }

        if self.flag == ItemOrderStatus.update {
            self.commentView.configureWith(comment: itemOrderViewModel.comment ?? "")
            self.quantityView.quantityLabel.text = String(describing: itemOrderViewModel.quantity ?? 1)
            self.quantityView.configureAddToCartButtonWith(flag: flag!, price: self.itemOrderViewModel.calculateTotal(Int(itemOrderViewModel.quantity ?? 1), price: Double(itemOrderViewModel.price!)))
        }
    }
    
    private func configureMyCartButton() {
        if itemOrderListViewModel.cartButtonIsEnabled  {
            let itemListVM = itemOrderListViewModel
            self.myCartButton.configureWithText(quantity: itemListVM.quantity, totalPrice: itemListVM.totalOrder)
            self.myCartButton.isHidden = false
        }
    }
    
    func updateQuantityView(quantity: Int, flag: ItemOrderStatus) {
        let price = itemMenuViewModel?.itemMenu.price
        
        if self.flag == ItemOrderStatus.create || self.flag == ItemOrderStatus.update {
            self.quantityView.quantityLabel.text = String(describing: quantity)
            self.quantityView.configureAddToCartButtonWith(flag: self.flag!, price: self.itemOrderViewModel.calculateTotal(quantity, price: price!))
            self.quantityView.decreaseButton.alpha = 1
            self.quantityView.decreaseButton.isEnabled = true
        } else if self.flag == ItemOrderStatus.remove {
            self.quantityView.quantityLabel.text = "0"
            self.quantityView.configureAddToCartButtonWith(flag: self.flag!, price: self.itemOrderViewModel.calculateTotal(Int(self.itemOrderViewModel.quantity ?? 0), price: price!))
            self.quantityView.decreaseButton.alpha = 0.5
            self.quantityView.decreaseButton.isEnabled = false
        }
    }
  
    private func configureButtons() {
        self.quantityView.addToCartButton.addTarget(self, action: #selector(self.addToCartButtonPressed(_:)), for: .touchUpInside)
        self.myCartButton.addTarget(self, action: #selector(self.goToCartScreen), for: .touchUpInside)
        self.quantityView.increaseButton.addTarget(self, action: #selector(self.increaseQuantityButtonPressed(_:)), for: .touchUpInside)
        self.quantityView.decreaseButton.addTarget(self, action: #selector(self.decreaseQuantityButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func configureStackView() {
        self.stackView.axis = .vertical
        self.stackView.distribution = .fill
        self.stackView.alignment = .fill
        self.stackView.spacing = 2.0
    }
    
    // MARK: - Setup Constraints
    
    private func setupScrollViewConstraints() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupStackViewConstraints() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.scrollView.bottomAnchor)
        ])
    }
    
    private func setupImageViewConstraints() {
        self.dishImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.dishImageView.heightAnchor.constraint(equalToConstant: 120),
            self.dishImageView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    private func setupInfoViewConstraints() {
        self.infoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.infoView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    private func setupCommentViewConstraints() {
        self.commentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.commentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    private func setupQuantityViewConstraints() {
        self.quantityView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.quantityView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
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

extension DishDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - ViewConfiguration
extension DishDetailsViewController: ViewConfiguration {
    func setupConstraints() {
        self.setupStackViewConstraints()
        self.setupScrollViewConstraints()
        self.setupImageViewConstraints()
        self.setupInfoViewConstraints()
        self.setupCommentViewConstraints()
        self.setupQuantityViewConstraints()
        self.setupMyCartButtonConstraints()
        self.setupSpinnerConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(self.scrollView)
        self.stackView.addArrangedSubview(self.dishImageView)
        self.stackView.addArrangedSubview(self.infoView)
        self.stackView.addArrangedSubview(self.commentView)
        self.stackView.addArrangedSubview(self.quantityView)
        self.scrollView.addSubview(self.stackView)
        self.scrollView.addSubview(self.myCartButton)
        view.addSubview(self.spinner)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        title = "Detalhes"
        self.configureStackView()
        self.configureButtons()
    }
}

// MARK: - CoreData

extension DishDetailsViewController {
    private func fetchOrder() {
        self.orderViewModel.fetch { orderViewModel in
            if let orderVM = orderViewModel {
                self.orderViewModel = orderVM
            }
        }
    }
    
    private func fetchItems() {
        if orderViewModel.order != nil {
            self.itemOrderListViewModel.fetchAll(orderViewModel: self.orderViewModel) { itemOrderListVM in
                if let itemOrderListVM = itemOrderListVM {
                    self.itemOrderListViewModel = itemOrderListVM
                }
            }
        }
    }
    
    private func fetchCurrentItem() {
        if orderViewModel.order != nil {
            self.itemOrderViewModel.fetchItem(itemMenuViewModel:  self.itemMenuViewModel, orderViewModel: self.orderViewModel) { itemOrderVM in
                if let itemOrderVM = itemOrderVM {
                    self.itemOrderViewModel = itemOrderVM
                }
            }
        }
    }
}

// MARK: - User Actions

extension DishDetailsViewController {
    @objc func increaseQuantityButtonPressed(_ sender: UIButton) {
        var quantity = Int(self.quantityView.quantityLabel.text!)
        quantity = quantity! + 1
        self.updateQuantityView(quantity: quantity!, flag: flag!)
    }
    
    @objc func decreaseQuantityButtonPressed(_ sender: UIButton) {
        var quantity = Int(self.quantityView.quantityLabel.text!)
        if self.flag == ItemOrderStatus.create && quantity! > 1 {
            quantity = quantity! - 1
        } else if self.flag == ItemOrderStatus.update && quantity! > 0 {
            quantity = quantity! - 1
            if quantity == 0 {
                self.flag = ItemOrderStatus.remove
            }
        }
        self.updateQuantityView(quantity: quantity!, flag: flag!)
    }
    
    @objc func addToCartButtonPressed(_ sender: UIButton) {
        let isRemoveItem = sender.titleLabel?.text!.contains(ItemOrderStatus.remove.rawValue)
        let name = self.itemMenuViewModel?.itemMenu.name
        let itemId = self.itemMenuViewModel?.itemMenu.itemId
        let price = self.itemMenuViewModel?.itemMenu.price
        let quantity = Int(self.quantityView.quantityLabel.text!)
        let comment = self.commentView.commentTextField.text ?? ""

        self.itemOrderViewModel.name = name!
        self.itemOrderViewModel.itemId = Int64(itemId!)
        self.itemOrderViewModel.price = price!
        self.itemOrderViewModel.quantity = Int64(quantity!)
        self.itemOrderViewModel.comment = comment
        
        if isRemoveItem! {
            itemOrderViewModel.removeItem(itemOrderViewModel: self.itemOrderViewModel, orderViewModel: self.orderViewModel, completion: { success in
                if success {
                    self.goToHomeScreen()
                }
            })
        } else {
            itemOrderViewModel.saveItem(itemOrderViewModel: self.itemOrderViewModel, orderViewModel: self.orderViewModel, completion: { success in
                if success {
                    self.goToCartScreen()
                }
            })
        }
    }
    
    @objc func goToCartScreen() {
        coordinator?.moveTo(flow: .menu(.cartScreen), data: [])
    }
    
    @objc func goToHomeScreen() {
        coordinator?.moveTo(flow: .menu(.menuScreen), data: [])
    }
}
