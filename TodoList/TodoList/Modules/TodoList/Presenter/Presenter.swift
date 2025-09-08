//
//  Presenter.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation
// protocol
// ссылка на интерактор
// ссылка на вью
// ссфлка на роутер
// class

protocol TodoListPresenterProtocol: AnyObject {
    var router: TodoListRouterProtocol? { get set }
    var interactor: TodoListInteractorProtocol? { get set }
    var view: TodoListViewProtocol? { get set }
    
    func interactorDidFetchTodos(with result: Result<[TodoItem], Error>)
}

class TodoListPresenter: TodoListPresenterProtocol {
    var router: (any TodoListRouterProtocol)?
    
    var interactor: (any TodoListInteractorProtocol)?
    
    var view: (any TodoListViewProtocol)?
    
    func interactorDidFetchTodos(with result: Result<[TodoItem], any Error>) {
        
    }
    
    
}
