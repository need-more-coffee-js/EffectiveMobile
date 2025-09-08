//
//  Router.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation
import UIKit
// class
// точка входа

typealias EntryPoint = TodoListViewProtocol & UIViewController

protocol TodoListRouterProtocol: AnyObject {
    var entry: EntryPoint? { get }
    
    static func start() -> TodoListRouterProtocol
}

class TodoListRouter: TodoListRouterProtocol {
    var entry: (any EntryPoint)?
    
    static func start() -> TodoListRouterProtocol {
        let router = TodoListRouter()
        
        var view: TodoListViewProtocol = TodoListViewController()
        
        var presenter: TodoListPresenterProtocol = TodoListPresenter()
        
        var interactor: TodoListInteractorProtocol = TodoListInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
}
