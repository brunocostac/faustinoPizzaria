//
//  DishCommentView.swift
//  pizzadelivery-ios
//
//  Created by Bruno Costa on 11/01/22.
//

import UIKit

class DishCommentView: UIView {
    
    // MARK: - Views
    
    private let commentLabel: UILabel = MyLabel(font: UIFont(name: "avenir", size: 20)!, textColor: .black, numberOfLines: 0)
    let commentTextField: UITextField = {
        let commentTextField = UITextField()
        commentTextField.borderStyle = .bezel
        commentTextField.placeholder = "Ex: Tirar cebola, maionese à parte, ponto da carne, etc"
        commentTextField.textColor = .darkGray
        commentTextField.font = UIFont(name: "avenir", size: 16)
        return commentTextField
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewConfiguration()
        commentLabel.text = "Observação"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    func configureWith(comment: String) {
        commentTextField.text = comment
    }
    
    // MARK: - Setup Constraints
    private func setupCommentLabelConstraints() {
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            commentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    private func setupCommentTextFieldConstraints() {
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentTextField.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 10),
            commentTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            commentTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            commentTextField.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 150)
    }
}

extension DishCommentView: ViewConfiguration {
    func setupConstraints() {
        setupCommentLabelConstraints()
        setupCommentTextFieldConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(commentLabel)
        addSubview(commentTextField)
    }
    
    func configureViews() {
        backgroundColor = .white
    }
}
