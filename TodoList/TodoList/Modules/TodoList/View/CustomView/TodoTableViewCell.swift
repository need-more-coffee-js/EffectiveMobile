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
        imageView.tintColor = Colors.iconCheckMark
        imageView.isHidden = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = TextStyles.taskTitleFont
        label.textColor = .red
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = TextStyles.taskDescriptionFont
        label.textColor = Colors.textColor
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = TextStyles.taskDateFont
        label.textColor = Colors.textColor
        return label
    }()
    
    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = Colors.backgroundAppColor
        selectionStyle = .none
        
        contentView.addSubview(checkmarkView)
        checkmarkView.addSubview(checkmarkImage)
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
        
        textStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(checkmarkView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Configure
    
    func configure(with todo: TodoItem) {
        titleLabel.text = todo.desc
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
        }
    }

    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}

