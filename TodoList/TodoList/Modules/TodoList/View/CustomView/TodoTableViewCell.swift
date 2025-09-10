//
//  TodoTableViewCell.swift
//  TodoList
//
//  Created by Денис Ефименков on 09.09.2025.
//

import UIKit
import SnapKit

final class TodoTableViewCell: UITableViewCell {
    
    // MARK: - UI
    private let checkmarkView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.backgroundColor = .clear
        return view
    }()
    
    private let checkmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .systemYellow
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var checkmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    
    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    // MARK: - Callback
    var onToggleCompleted: (() -> Void)?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = Colors.backgroundAppColor
        
        contentView.addSubview(checkmarkView)
        checkmarkView.addSubview(checkmarkImage)
        checkmarkView.addSubview(checkmarkButton)
        contentView.addSubview(textStack)
        
        checkmarkView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        checkmarkImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        checkmarkButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(checkmarkView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .tertiaryLabel
    }
    
    // MARK: - Configure
    func configure(with todo: TodoItem) {
        descriptionLabel.text = todo.descriptionTask?.isEmpty == false ? todo.descriptionTask : "Без описания"
        dateLabel.text = formatDate(todo.createdAt)
        
        if todo.isCompleted {
            checkmarkImage.isHidden = false
            let attributeString = NSMutableAttributedString(string: todo.desc)
            attributeString.addAttribute(.strikethroughStyle,
                                         value: NSUnderlineStyle.single.rawValue,
                                         range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
            titleLabel.textColor = .secondaryLabel
            descriptionLabel.textColor = .secondaryLabel
            dateLabel.textColor = .secondaryLabel
        } else {
            checkmarkImage.isHidden = true
            titleLabel.attributedText = nil
            titleLabel.text = todo.desc
            titleLabel.textColor = Colors.textColor
            descriptionLabel.textColor = Colors.textColor
            dateLabel.textColor = Colors.textColor
        }
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    // MARK: - Actions
    @objc private func checkmarkTapped() {
        onToggleCompleted?()
    }
}


