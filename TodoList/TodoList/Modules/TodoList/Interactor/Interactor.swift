//
//  Interactor.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation
// protocol
// ссылка на презентер
// class

protocol TodoListInteractorProtocol {
    var presenter: TodoListPresenterProtocol? { get set }
    
    func getTodos()
    
}

class TodoListInteractor: TodoListInteractorProtocol {
    var presenter: TodoListPresenterProtocol?
    
    func getTodos() {
    }
    
    
}

