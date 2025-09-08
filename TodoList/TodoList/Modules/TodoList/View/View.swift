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
        print("Add task tapped")
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
}

