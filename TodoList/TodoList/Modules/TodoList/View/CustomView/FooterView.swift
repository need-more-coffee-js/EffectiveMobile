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
        label.font = FooterTextStyles.footerFont
        label.textColor = Colors.textColor
        label.text = "0 задач"
        return label
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "square.and.pencil")
        button.setImage(image, for: .normal)
        button.tintColor = Colors.iconCheckMark
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
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

        addSubview(tasksCountLabel)
        addSubview(addButton)

        tasksCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()     
        }

        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.firstBaseline.equalTo(tasksCountLabel.snp.firstBaseline)
            make.height.equalTo(24)
            make.width.equalTo(30)
        }
        
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }

    @objc private func addTapped() {
        onAddTapped?()
    }

    func updateTasksCount(_ count: Int) {
        tasksCountLabel.text = "\(count) \(count.tasksWord)"
    }
}

