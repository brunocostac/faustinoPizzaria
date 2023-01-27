//
//  OrderTableViewCell.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 07/01/22.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    let titleLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 14)!, textColor: .black, numberOfLines: 0)
    let descriptionLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 14)!, textColor: .black, numberOfLines: 2)
    let priceLabel: UILabel = MyLabel(font: UIFont(name: "avenir-heavy", size: 14)!, textColor: .black, numberOfLines: 0)
    let statusLabel: UILabel =  MyLabel(font: UIFont(name: "avenir-heavy", size: 16)!, textColor: .gray, numberOfLines: 0)
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithText(orderVM: OrderViewModel, itemOrderListVM: ItemOrderListViewModel) {
        self.titleLabel.text = "Data do pedido: \(String(describing: orderVM.dateRequest))"
        self.descriptionLabel.text = itemOrderListVM.itemsDescription
        self.priceLabel.text = "Valor Total: R$ \(itemOrderListVM.totalOrder)"
        self.statusLabel.text = "Status: \(comparingDates(firstDate: Date(), secondDate: (orderVM.order?.dateCompletion!)!))"
    }
    
    func comparingDates(firstDate: Date, secondDate: Date) -> String {
        if firstDate.compare(secondDate) == .orderedAscending {
            return "Em andamento"
        } else if firstDate.compare(secondDate) == .orderedDescending {
          return "Entregue"
        } else {
          return "Entregue"
        }
    }
    
    // MARK: - Setup Constraints
    
    private func setupTitleLabelConstraints() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            self.titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    private func setupDescriptionLabelConstraints() {
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo:  self.titleLabel.bottomAnchor, constant: 10),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    private func setupPriceLabelConstraints() {
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            self.priceLabel.topAnchor.constraint(equalTo:  self.descriptionLabel.bottomAnchor, constant: 10),
            self.priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    private func setupStatusLabelConstraints() {
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            self.statusLabel.topAnchor.constraint(equalTo:  self.priceLabel.bottomAnchor, constant: 10),
            self.statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
}

// MARK: - ViewConfiguration

extension OrderTableViewCell: ViewConfiguration {
    func setupConstraints() {
        self.setupTitleLabelConstraints()
        self.setupDescriptionLabelConstraints()
        self.setupPriceLabelConstraints()
        self.setupStatusLabelConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(self.titleLabel)
        addSubview(self.descriptionLabel)
        addSubview(self.priceLabel)
        addSubview(self.statusLabel)
    }
    
    func configureViews() {
        backgroundColor = .white
        selectionStyle = .none
    }
}
