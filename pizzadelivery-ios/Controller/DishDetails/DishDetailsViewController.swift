//
//  MenuDetailsViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 11/01/22.
//

import UIKit

class DishDetailsViewController: UIViewController, MenuBaseCoordinated {
    
    // View Model
    var itemOrder: ItemOrder
    
    // MARK: - Views
    
    var coordinator: MenuBaseCoordinator?
    
    private let imageView = DishImageView(frame: .zero)
    
    private let infoView = DishInfoView()
    
    private let commentView = DishCommentView()
    
    private let quantityView = DishQuantityView()
    
    private let stackView = UIStackView()
    
    private let scrollView = UIScrollView()
    
    private let myCartButton = MyCartButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Initialization
    
    required init(coordinator: MenuBaseCoordinator) {
        itemOrder = ItemOrder(name: "aa", itemId: "123", quantity: 1, price: 36.59, comment: "")
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    @objc func addToMyCart() {
       print("add to cart / save in coredata")
    }
    
    @objc func increaseQuantity() {
        itemOrder.increaseQuantity()
        updateUI()
    }
    
    @objc func decreaseQuantity() {
        itemOrder.decreaseQuantity()
        updateUI()
    }
    
    @objc func goToCartScreen() {
        coordinator?.moveTo(flow: .menu(.cartScreen), userData: nil)
    }
    
    func updateUI() {
        quantityView.quantityLabel.text = "\(itemOrder.quantity)"
        quantityView.addToCartButton.setTitle("Adicionar R$ \(itemOrder.calculateTotal())", for: .normal)
    }
    
    func configureButtons() {
        quantityView.addToCartButton.addTarget(self, action: #selector(addToMyCart), for: .touchUpInside)
        myCartButton.addTarget(self, action: #selector(goToCartScreen), for: .touchUpInside)
        quantityView.increaseButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        quantityView.decreaseButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
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
       imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           imageView.heightAnchor.constraint(equalToConstant: 120),
           imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
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
        stackView.addArrangedSubview(imageView)
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
