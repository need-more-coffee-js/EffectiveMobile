//
//  View.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation
import UIKit

protocol TodoListViewProtocol: AnyObject {
    var presenter: TodoListPresenterProtocol? { get set }
    func update(with todos: [TodoItem])
    func update(with error: Error)
}

class TodoListViewController: UIViewController, TodoListViewProtocol, UITableViewDelegate, UITableViewDataSource {
    
    var presenter: TodoListPresenterProtocol?
    private var todos: [TodoItem] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    private let footerView = TodoListFooterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.interactor?.getTodos()
    }
    
    func setupUI(){
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(120)
        }
        
        view.addSubview(footerView)
        footerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        footerView.onAddTapped = { [weak self] in
            self?.addTask()
        }
        
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    @objc func addTask() {
        if (presenter?.router?.entry) != nil {
            presenter?.router?.openTaskEditor(from: self, task: nil)
        }
    }

    
    
    
    func update(with todos: [TodoItem]) {
        self.todos = todos
        footerView.updateTasksCount(todos.count)
        tableView.reloadData()
        tableView.isHidden = false
    }
    
    func update(with error: Error) {
        print("Failed to fetch todos: \(error)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todos[indexPath.row].desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let todo = todos[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.presenter?.router?.openTaskEditor(from: self, task: todo)
            }

            let share = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let activity = UIActivityViewController(activityItems: [todo.desc], applicationActivities: nil)
                self.present(activity, animated: true)
            }

            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                print("Удаляем задачу \(todo.desc)")
            }

            return UIMenu(title: "", children: [edit, share, delete])
        }
    }

}

