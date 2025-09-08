//
//  Interactor.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation

protocol TodoListInteractorProtocol {
    var presenter: TodoListPresenterProtocol? { get set }
    func getTodos()
}

class TodoListInteractor: TodoListInteractorProtocol {
    weak var presenter: TodoListPresenterProtocol?
    
    private let apiService: TodoAPIServiceProtocol
    
    init(apiService: TodoAPIServiceProtocol = TodoAPIService()) {
        self.apiService = apiService
    }
    
    func getTodos() {
        apiService.fetchTodos { [weak self] items in
            guard let self = self else { return }
            
            if items.isEmpty {
                self.presenter?.interactorDidFetchTodos(with: .failure(FetchError.failed))
            } else {
                self.presenter?.interactorDidFetchTodos(with: .success(items))
            }
        }
    }
}


