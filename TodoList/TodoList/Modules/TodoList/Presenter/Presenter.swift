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
    var router: TodoListRouterProtocol? { get set }
    var interactor: TodoListInteractorProtocol? { get set }
    var view: TodoListViewProtocol? { get set }
    
    func interactorDidFetchTodos(with result: Result<[TodoItem], Error>)
}

class TodoListPresenter: TodoListPresenterProtocol {
    var router: TodoListRouterProtocol?
    var interactor: TodoListInteractorProtocol?
    var view: TodoListViewProtocol?
    
    func interactorDidFetchTodos(with result: Result<[TodoItem], Error>) {
        switch result {
        case .success(let items):
            view?.update(with: items)
        case .failure(let error):
            view?.update(with: error)
        }
    }
}

