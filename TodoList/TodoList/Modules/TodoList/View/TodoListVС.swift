//
//  View.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import UIKit
import SnapKit

protocol TodoListViewProtocol: AnyObject {
    var presenter: TodoListPresenterProtocol? { get set }
    func showTodos(_ todos: [TodoItem])
    func showError(_ error: Error)
}

final class TodoListViewController: UIViewController, TodoListViewProtocol {
    var presenter: TodoListPresenterProtocol?
    private var todos: [TodoItem] = []

    private let searchBarView = TodoSearchBarView()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = Colors.backgroundAppColor
        tableView.isHidden = true
        return tableView
    }()
    private let footerView = TodoListFooterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        hideKeyboardWHentap() 
    }

    private func setupUI() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(searchBarView)
        view.addSubview(tableView)
        view.addSubview(footerView)

        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }
        footerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(90)
        }

        tableView.delegate = self
        tableView.dataSource = self

        searchBarView.onTextChanged = { [weak self] text in
            self?.presenter?.didSearch(text: text)
        }
        footerView.onAddTapped = { [weak self] in
            self?.presenter?.didSelectAdd()
        }
    }

    // MARK: - View Protocol
    func showTodos(_ todos: [TodoItem]) {
        self.todos = todos
        footerView.updateTasksCount(todos.count)
        tableView.reloadData()
        tableView.isHidden = todos.isEmpty
    }

    func showError(_ error: Error) {
        print("Ошибка загрузки задач: \(error)")
    }
}

// MARK: - TableView
extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = presenter?.todos[indexPath.row]
        if let todo = todo {
            cell.configure(with: todo)
            cell.onToggleCompleted = { [weak self] in
                self?.presenter?.didToggleCompleted(todo: todo)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        let todo = todos[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self = self else { return nil }

            let edit = UIAction(title: "Редактировать",
                                image: UIImage(systemName: "pencil")) { _ in
                self.presenter?.didEdit(todo: todo)
            }

            let delete = UIAction(title: "Удалить",
                                  image: UIImage(systemName: "trash"),
                                  attributes: .destructive) { _ in
                self.presenter?.didDelete(todo: todo)
            }

            let share = UIAction(title: "Поделиться",
                                 image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let text = "Задача: \(todo.desc)"
                let activityVC = UIActivityViewController(activityItems: [text],
                                                          applicationActivities: nil)
                self.present(activityVC, animated: true)
            }

            return UIMenu(title: "", children: [edit, share, delete])
        }
    }

}

