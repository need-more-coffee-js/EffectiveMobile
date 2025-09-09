//
//  EditorView.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import UIKit
import SnapKit

protocol TaskEditorViewProtocol: AnyObject {
    var presenter: TaskEditorPresenterProtocol? { get set }
    func showTask(title: String?,date: Date?, description: String?)
    func close()
}

final class TaskEditorViewController: UIViewController, TaskEditorViewProtocol {
    var presenter: TaskEditorPresenterProtocol?

    private lazy var titleField: UITextField = {
        let tf = UITextField()
        tf.font = TaskEditorStyle.titleFont
        tf.textColor = Colors.textColor
        tf.placeholder = "Введите заголовок"
        return tf
    }()
    private lazy var dateField: UILabel = {
        let df = UILabel()
        df.font = TaskEditorStyle.dateFont
        df.textColor = Colors.textColor
        return df
    }()
    private lazy var descriptionField: UITextView = {
        let df = UITextView()
        df.font = TaskEditorStyle.descriptionFont
        df.textColor = Colors.textColor
        df.backgroundColor = Colors.backgroundAppColor
        return df
    }()
    
    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleField, dateField, descriptionField])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }

    private func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Назад",
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )
        
        view.backgroundColor = Colors.backgroundAppColor
        view.addSubview(textStack)

        textStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    @objc private func didTapClose() {
        presenter?.didTapSave(title: titleField.text, description: descriptionField.text)
        close()
    }

    // MARK: - View Protocol
    func showTask(title: String?, date: Date?, description: String?) {
        titleField.text = title
        descriptionField.text = description
        dateField.text = formatDate(date)
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }
}
