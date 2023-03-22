//
//  MenuDetailsViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 11/01/22.
//

import UIKit

class DishDetailsViewController: UIViewController, HomeBaseCoordinated, DishDetailsViewModelDelegate {

    // MARK: - ViewModel
    
    public var itemMenuViewModel: ItemMenuViewModel?
    public var dishDetailsViewModel: DishDetailsViewModel?
    
    // MARK: - Views
    
    var coordinator: HomeBaseCoordinator?
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
        self.dishDetailsViewModel = DishDetailsViewModel(itemMenuViewModel: itemMenuViewModel)
        self.dishDetailsViewModel?.delegate = self
        self.dishDetailsViewModel?.viewDidAppear()
        self.spinner.stopAnimating()
    }
    
    // MARK: - Initialization
    
    required init(coordinator: HomeBaseCoordinator) {
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
    
    func didConfigureDishDetails(url: String, itemName: String, description: String, price: String, flag: ItemOrderStatus, comment: String) {
        self.dishImageView.configureWith(url: url)
        self.infoView.configure(name: itemName, description: description, price: price)
        self.quantityView.configureAddToCartButton(flag: flag, price: price)
        self.commentView.configure(comment: comment)
    }
    
    func didConfigureMyCartButton(quantity: String, totalItemOrder: String, isHiddenButton: Bool) {
        self.myCartButton.configure(quantity: quantity, totalPrice: totalItemOrder)
        self.myCartButton.isHidden = isHiddenButton
    }
    
    func didUpdateQuantityView(quantity: String, decreaseButtonAlpha: Double, decreaseButtonIsEnabled: Bool, flag: ItemOrderStatus, total: String) {
        self.quantityView.quantityLabel.text = quantity
        self.quantityView.decreaseButton.alpha = decreaseButtonAlpha
        self.quantityView.decreaseButton.isEnabled = decreaseButtonIsEnabled
        self.quantityView.configureAddToCartButton(flag: flag, price: total)
    }
        
    private func configureButtons() {
        self.quantityView.addToCartButton.addTarget(self, action: #selector(self.addToCartButtonPressed(_:)), for: .touchUpInside)
        self.myCartButton.addTarget(self, action: #selector(self.didGoToCartScreen), for: .touchUpInside)
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


// MARK: - User Actions

extension DishDetailsViewController {
    @objc func increaseQuantityButtonPressed(_ sender: UIButton) {
        let quantity = Int(self.quantityView.quantityLabel.text!)!
        self.dishDetailsViewModel?.increaseQuantity(quantity: quantity)
    }
    
    @objc func decreaseQuantityButtonPressed(_ sender: UIButton) {
        let quantity = Int(self.quantityView.quantityLabel.text!)!
        self.dishDetailsViewModel?.decreaseQuantity(quantity: quantity)
    }
    
    @objc func addToCartButtonPressed(_ sender: UIButton) {
        if let isRemoveItem = sender.titleLabel?.text!.contains(ItemOrderStatus.remove.rawValue) {
            let quantity = Int(self.quantityView.quantityLabel.text!)!
            let comment = self.commentView.commentTextField.text ?? ""
            self.dishDetailsViewModel?.addToCart(isRemoveItem: isRemoveItem, quantity: quantity, comment: comment)
        }
    }
    
    func didGoToHomeScreen() {
        coordinator?.moveTo(flow: .home(.homeScreen), data: [])
    }
    
    @objc func didGoToCartScreen() {
        coordinator?.moveTo(flow: .home(.cartScreen), data: [])
    }
}
