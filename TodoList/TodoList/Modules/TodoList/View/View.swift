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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter?.interactor?.getTodos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with todos: [TodoItem]) {
        self.todos = todos
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

