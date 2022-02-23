//
//  MenuDetailsViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 11/01/22.
//

import UIKit
import CoreData

class DishDetailsViewController: UIViewController, MenuBaseCoordinated {
    
    // MARK: - ViewModel
    
    public var itemMenuViewModel: ItemMenuViewModel?
    private var orderViewModel: OrderViewModel?
    private var itemOrderViewModel: ItemOrderViewModel?
    private var itemOrderListViewModel: ItemOrderListViewModel?
    
    // MARK: - Variables
    
    private var initialFlag = ItemOrderStatus.create
    
    // MARK: - Views
    
    var coordinator: MenuBaseCoordinator?
    private let dishImageView = DishImageView(frame: .zero)
    private let infoView = DishInfoView()
    private let commentView = DishCommentView()
    private let quantityView = DishQuantityView()
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    private let myCartButton = MyCartButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrder()
        fetchItems()
        fetchCurrentItem()
        configureMenuDetails()
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
    
    func fetchOrder() {
        CoreDataHelper().fetchCurrentOrder { currentOrder in
            if let currentOrder = currentOrder {
                self.orderViewModel = OrderViewModel(currentOrder)
            }
        }
    }
    
    func fetchItems() {
        if orderViewModel != nil {
            itemOrderListViewModel = CoreDataHelper().fetchItemsCurrentOrder(orderViewModel: orderViewModel)
        }
    }
    
    func fetchCurrentItem() {
        if orderViewModel != nil {
            itemOrderViewModel = CoreDataHelper().fetchCurrentItem(itemMenuViewModel: itemMenuViewModel, orderViewModel: orderViewModel)
        }
    }
    // MARK: - Functions
    
    func configureMenuDetails() {
        if let itemMenuVM = itemMenuViewModel?.itemMenu {
            dishImageView.configureLayout(url: itemMenuVM.imageUrl)
            infoView.configureLayout(name: itemMenuVM.name, description: itemMenuVM.description, price: itemMenuVM.price)
            quantityView.addToCartButton.setTitle("\(initialFlag.rawValue) R$ \(itemMenuVM.price)", for: .normal)
        }
        if let itemListVM = itemOrderListViewModel {
            myCartButton.configureLayout(quantity: itemListVM.quantity, totalPrice: itemListVM.totalOrder)
            myCartButton.isHidden = false
        }
        if let itemOrderVM = itemOrderViewModel {
            initialFlag = ItemOrderStatus.update
            updateUI(quantity: (Int(itemOrderVM.quantity)), comment: itemOrderVM.comment, flag: initialFlag)
        }
    }
    
    func getCalcTotal(_ quantity: Int, price: Double) -> String {
        let total = Double(quantity) * Double(price)
        return String(format: "%.2f", total)
    }
    
    func updateUI(quantity: Int, comment: String = "", flag: ItemOrderStatus?) {
        let currentFlag = flag ?? initialFlag
        let total = getCalcTotal(quantity, price: itemMenuViewModel!.itemMenu.price)
        let titleButton = "\(currentFlag.rawValue) R$ \(total)"
        
        if currentFlag == ItemOrderStatus.create || currentFlag == ItemOrderStatus.update {
            quantityView.addToCartButton.setTitle(titleButton, for: .normal)
            quantityView.quantityLabel.text = "\(quantity)"
        } else if currentFlag == ItemOrderStatus.remove {
            quantityView.addToCartButton.setTitle(titleButton, for: .normal)
            quantityView.quantityLabel.text = "0"
        }
        commentView.commentTextField.text = comment
    }
    
    func updateDecreaseButton(button: UIButton, isEnabled: Bool, bgColor: UIColor = .darkGray) {
        button.isEnabled = isEnabled
        button.backgroundColor = bgColor
    }
    
    func configureButtons() {
        quantityView.addToCartButton.addTarget(self, action: #selector(addOrRemoveButtonPressed(_:)), for: .touchUpInside)
        myCartButton.addTarget(self, action: #selector(goToCartScreen), for: .touchUpInside)
        quantityView.increaseButton.addTarget(self, action: #selector(changeQuantityButtonPressed(_:)), for: .touchUpInside)
        quantityView.decreaseButton.addTarget(self, action: #selector(changeQuantityButtonPressed(_:)), for: .touchUpInside)
    }
    
    func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 2.0
    }
    
    // MARK: - Setup Constraints
    
    private func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setupImageViewConstraints() {
        dishImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dishImageView.heightAnchor.constraint(equalToConstant: 120),
            dishImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    private func setupInfoViewConstraints() {
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupCommentViewConstraints() {
        commentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupQuantityViewConstraints() {
        quantityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quantityView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
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
extension DishDetailsViewController: ViewConfiguration {
    func setupConstraints() {
        setupStackViewConstraints()
        setupScrollViewConstraints()
        setupImageViewConstraints()
        setupInfoViewConstraints()
        setupCommentViewConstraints()
        setupQuantityViewConstraints()
        setupMyCartButtonConstraints()
    }
    
    func buildViewHierarchy() {
        view.addSubview(scrollView)
        stackView.addArrangedSubview(dishImageView)
        stackView.addArrangedSubview(infoView)
        stackView.addArrangedSubview(commentView)
        stackView.addArrangedSubview(quantityView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(myCartButton)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        configureStackView()
        configureButtons()
    }
}

// MARK: - User Actions

extension DishDetailsViewController {
    
    @objc func addOrRemoveButtonPressed(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel?.text
        let name = itemMenuViewModel?.itemMenu.name
        let itemId = itemMenuViewModel?.itemMenu.itemId
        let price = itemMenuViewModel?.itemMenu.price
        let quantity = Int(quantityView.quantityLabel.text!)
        let comment = commentView.commentTextField.text ?? ""
        let isToRemoveItem = buttonTitle?.contains(ItemOrderStatus.remove.rawValue)
        
        itemOrderViewModel = ItemOrderViewModel(name: name!,
                                                itemId: Int64(itemId!),
                                                price: price!,
                                                quantity: Int64(quantity!),
                                                comment: comment)
        if isToRemoveItem! {
            CoreDataHelper().removeItem(itemOrderViewModel: itemOrderViewModel, orderViewModel: orderViewModel)
            goToHomeScreen()
        } else {
            CoreDataHelper().saveItem(itemOrderViewModel: itemOrderViewModel, orderViewModel: orderViewModel)
            goToCartScreen()
        }
    }
    
    @objc func changeQuantityButtonPressed(_ sender: UIButton) {
        var newQuantity = Int(quantityView.quantityLabel.text!)
        var currentFlag: ItemOrderStatus?
        
        if sender.titleLabel?.text == "+" {
            newQuantity = newQuantity! + 1
            currentFlag = initialFlag
            updateDecreaseButton(button: quantityView.decreaseButton, isEnabled: true)
            updateUI(quantity: newQuantity!, flag: currentFlag)
        } else if sender.titleLabel?.text == "-" && initialFlag == ItemOrderStatus.update {
            if newQuantity! > 0 {
                newQuantity = newQuantity! - 1
                updateUI(quantity: newQuantity!, flag: currentFlag)
                if newQuantity! == 0 {
                    currentFlag = ItemOrderStatus.remove
                    updateDecreaseButton(button: quantityView.decreaseButton, isEnabled: false, bgColor: .lightGray)
                    updateUI(quantity: Int(itemOrderViewModel!.quantity), flag: currentFlag)
                }
            }
        } else if sender.titleLabel?.text == "-" && initialFlag == ItemOrderStatus.create {
            if newQuantity! > 1 {
                newQuantity = newQuantity! - 1
                currentFlag = ItemOrderStatus.create
                updateUI(quantity: newQuantity!, flag: currentFlag)
            }
        }
    }
    
    @objc func goToCartScreen() {
        coordinator?.moveTo(flow: .menu(.cartScreen), data: [])
    }
    
    @objc func goToHomeScreen() {
        coordinator?.moveTo(flow: .menu(.menuScreen), data: [])
    }
}
