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
    func close()
    func showTask(title: String?, description: String?)
}

final class TaskEditorViewController: UIViewController, TaskEditorViewProtocol {
    var presenter: TaskEditorPresenterProtocol?

    private let titleField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Заголовок"
        tf.borderStyle = .roundedRect
        return tf
    }()

    private let descriptionField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Описание"
        tf.borderStyle = .roundedRect
        return tf
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        view.addSubview(titleField)
        view.addSubview(descriptionField)
        view.addSubview(saveButton)

        titleField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        descriptionField.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }

        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    @objc private func saveTapped() {
        presenter?.didTapSave(title: titleField.text, description: descriptionField.text)
    }

    func close() {
        navigationController?.popViewController(animated: true)
    }

    func showTask(title: String?, description: String?) {
        titleField.text = title
        descriptionField.text = description
    }
}

