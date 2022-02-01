//
//  MenuDetailsViewController.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 11/01/22.
//

import UIKit
import CoreData

class DishDetailsViewController: UIViewController, MenuBaseCoordinated {
    
    var itemMenuViewModel: ItemMenuViewModel?
    
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
        setupViewModelAtViews()
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
    
    // MARK: - Functions
    
    func setupViewModelAtViews() {
        if let viewModel = itemMenuViewModel?.itemMenu {
            dishImageView.configureLayout(url: viewModel.imageUrl)
            infoView.configureLayout(name: viewModel.name, description: viewModel.description, price: viewModel.price)
        }
    }
    
    @objc func addToMyCart() {
    }
    
    @objc func increaseQuantity() {
        if let currentQuantity = quantityView.quantityLabel.text {
            let newQuantity = Int(currentQuantity)! + 1
            quantityView.quantityLabel.text = "\(newQuantity)"
        }
        
        updateUI()
    }
    
    @objc func decreaseQuantity() {
        if let currentQuantity = quantityView.quantityLabel.text {
            if Int(currentQuantity)! > 1 {
                let newQuantity = Int(currentQuantity)! - 1
                quantityView.quantityLabel.text = "\(newQuantity)"
            }
        }
    }
    
    @objc func goToCartScreen() {
        let date = Date()
        coordinator?.moveTo(flow: .menu(.cartScreen), data: date)
    }
    
    func updateUI() {
        //quantityView.quantityLabel.text = "\(itemOrder.quantity)"
        //quantityView.addToCartButton.setTitle("Adicionar R$ \(itemOrder.calculateTotal())", for: .normal)
    }
    
    func configureButtons() {
        quantityView.addToCartButton.addTarget(self, action: #selector(addToMyCart), for: .touchUpInside)
        myCartButton.addTarget(self, action: #selector(goToCartScreen), for: .touchUpInside)
        quantityView.increaseButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        quantityView.decreaseButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        myCartButton.isHidden = true
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
