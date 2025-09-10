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
        df.isScrollEnabled = false 
        df.textContainerInset = .zero
        df.textContainer.lineFragmentPadding = 0
        df.backgroundColor = .red
        return df
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

        view.addSubview(titleField)
        view.addSubview(dateField)
        view.addSubview(descriptionField)

        titleField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(40)
        }

        dateField.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(20)
        }

        descriptionField.snp.makeConstraints { make in
            make.top.equalTo(dateField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.greaterThanOrEqualTo(100)
        }
        
        descriptionField.delegate = self
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

extension TaskEditorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        UIView.setAnimationsEnabled(false)
        textView.invalidateIntrinsicContentSize()
        textView.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
}
