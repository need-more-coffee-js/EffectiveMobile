//
//  FooterView.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import UIKit
import SnapKit

final class TodoListFooterView: UIView {

    private let tasksCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.text = "0 задач"
        return label
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        button.backgroundColor = .systemYellow
        button.tintColor = .black
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var footerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [tasksCountLabel, addButton])
        stack.axis = .horizontal
        //stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()

    var onAddTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = Colors.backgroundGray

        addSubview(footerStack)
        footerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(32)
        }
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }

    @objc private func addTapped() {
        onAddTapped?()
    }

    func updateTasksCount(_ count: Int) {
        tasksCountLabel.text = "\(count) задач"
    }
}

