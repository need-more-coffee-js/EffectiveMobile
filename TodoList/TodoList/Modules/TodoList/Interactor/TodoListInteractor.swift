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
    func toggleCompleted(todo: TodoItem)
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
        coreDataService.fetch { [weak self] localModels in
            guard let self = self else { return }
            let localTodos = localModels.map { $0.toDomain() }

            self.apiService.fetchTodos { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let apiTodos):
                    let merged = self.merge(local: localTodos, api: apiTodos)
                    self.presenter?.didFetchTodos(merged)
                case .failure:
                    self.presenter?.didFetchTodos(localTodos)
                }
            }
        }
    }

    private func merge(local: [TodoItem], api: [TodoItem]) -> [TodoItem] {
        let localApiIds = Set(local.compactMap { $0.apiId })
        let filteredApi = api.filter { ($0.apiId != nil) ? !localApiIds.contains($0.apiId!) : true }
        return local + filteredApi
    }

    func delete(todo: TodoItem) {
        guard let uuid = todo.uuid else { return }
        coreDataService.deleteItem(id: uuid) { [weak self] in self?.getTodos() }
    }

    func toggleCompleted(todo: TodoItem) {
        guard let uuid = todo.uuid else { return }
        coreDataService.updateItem(
            id: uuid,
            title: todo.desc,
            description: todo.descriptionTask,
            isCompleted: !todo.isCompleted
        ) { [weak self] in self?.getTodos() }
    }
}



