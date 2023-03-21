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
        self.setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
    func configure(comment: String) {
        self.commentTextField.text = comment
    }
    
    // MARK: - Setup Constraints
    private func setupCommentLabelConstraints() {
        self.commentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.commentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            self.commentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    private func setupCommentTextFieldConstraints() {
        self.commentTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.commentTextField.topAnchor.constraint(equalTo: self.commentLabel.bottomAnchor, constant: 10),
            self.commentTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            self.commentTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            self.commentTextField.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 150)
    }
}

extension DishCommentView: ViewConfiguration {
    func setupConstraints() {
        self.setupCommentLabelConstraints()
        self.setupCommentTextFieldConstraints()
    }
    
    func buildViewHierarchy() {
        addSubview(self.commentLabel)
        addSubview(self.commentTextField)
    }
    
    func configureViews() {
        backgroundColor = .white
        self.commentLabel.text = "Observação"
    }
}
