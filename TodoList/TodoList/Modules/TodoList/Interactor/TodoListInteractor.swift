//
//  Interactor.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation

protocol TodoListInteractorProtocol: AnyObject {
    var presenter: TodoListInteractorOutputProtocol? { get set }
    func getTodos()
    func delete(todo: TodoItem)
}

protocol TodoListInteractorOutputProtocol: AnyObject {
    func didFetchTodos(_ todos: [TodoItem])
    func didFailFetchingTodos(_ error: Error)
}

final class TodoListInteractor: TodoListInteractorProtocol {
    weak var presenter: TodoListInteractorOutputProtocol?

    private let apiService: TodoAPIServiceProtocol
    private let coreDataService: CoreDataServiceProtocol

    init(apiService: TodoAPIServiceProtocol = TodoAPIService(),
         coreDataService: CoreDataServiceProtocol = CoreDataService()) {
        self.apiService = apiService
        self.coreDataService = coreDataService
    }

    func getTodos() {
        let localTodos = coreDataService.fetch().map { $0.toDomain() }

        apiService.fetchTodos { [weak self] apiTodos in
            guard let self = self else { return }
            let combined = localTodos + apiTodos.filter { $0.uuid == nil }

            if combined.isEmpty {
                self.presenter?.didFailFetchingTodos(FetchError.failed)
            } else {
                self.presenter?.didFetchTodos(combined)
            }
        }
    }

    func delete(todo: TodoItem) {
        if let uuid = todo.uuid {
            coreDataService.deleteItem(id: uuid)
        }
        getTodos()
    }
}



