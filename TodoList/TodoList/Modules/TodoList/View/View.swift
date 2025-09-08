//
//  View.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation
import UIKit
// vc
// protocol
// ссылка на презентер
protocol TodoListViewProtocol {
    var presenter: TodoListPresenterProtocol? { get set }
    
    func update(with todos: [TodoItem])
    func update(with error: Error)
}

class TodoListViewController: UIViewController, TodoListViewProtocol, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    var presenter: (any TodoListPresenterProtocol)?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .red
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with todos: [TodoItem]) {
        
    }
    
    func update(with error: any Error) {
        
    }
    
    
}
