//
//  Presenter.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation

enum FetchError: Error {
    case failed
}

protocol TodoListPresenterProtocol: AnyObject {
    var view: TodoListViewProtocol? { get set }
    var interactor: TodoListInteractorProtocol? { get set }
    var router: TodoListRouterProtocol? { get set }
    var todos: [TodoItem] { get }
    
    func viewDidLoad()
    func didSelectAdd()
    func didDelete(todo: TodoItem)
    func didSearch(text: String)
    func didEdit(todo: TodoItem)
    func didToggleCompleted(todo: TodoItem)
}

protocol TodoListPresenterOutput: AnyObject {
    func didFetchTodos(_ todos: [TodoItem])
}

final class TodoListPresenter: TodoListPresenterProtocol {
    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorProtocol?
    var router: TodoListRouterProtocol?

    private(set) var todos: [TodoItem] = []

    func viewDidLoad() {
        interactor?.getTodos()
    }

    func didSelectAdd() {
        router?.openTaskEditor(onSave: { [weak self] in
            self?.interactor?.getTodos()
        })
    }


    func didDelete(todo: TodoItem) {
        interactor?.delete(todo: todo)
    }
    
    func didEdit(todo: TodoItem) {
        router?.openTaskEditor(with: todo, onSave: { [weak self] in
            self?.interactor?.getTodos()
        })
    }

    func didSearch(text: String) {
        let filtered = todos.filter { $0.desc.lowercased().contains(text.lowercased()) }
        view?.showTodos(filtered)
    }
    
    func didToggleCompleted(todo: TodoItem) {
        interactor?.toggleCompleted(todo: todo)
    }
}

// MARK: - Interactor Output
extension TodoListPresenter: TodoListInteractorOutputProtocol {
    func didFetchTodos(_ todos: [TodoItem]) {
        self.todos = todos
        view?.showTodos(todos)
    }

    func didFailFetchingTodos(_ error: Error) {
        view?.showError(error)
    }
}



