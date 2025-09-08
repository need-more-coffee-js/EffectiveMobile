//
//  Router.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation
import UIKit

typealias EntryPoint = TodoListViewProtocol & UIViewController

protocol TodoListRouterProtocol: AnyObject {
    var entry: EntryPoint? { get }
    static func start() -> TodoListRouterProtocol
    func openTaskEditor(from vc: UIViewController, task: TodoItem?)
}

class TodoListRouter: TodoListRouterProtocol {
    var entry: EntryPoint?
    
    static func start() -> TodoListRouterProtocol {
        let router = TodoListRouter()
        
        let view = TodoListViewController()
        let presenter = TodoListPresenter()
        let interactor = TodoListInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.entry = view
        
        return router
    }
}

extension TodoListRouter {
    func openTaskEditor(from vc: UIViewController, task: TodoItem?) {
        let editorVC = TaskEditorRouter.start(with: task)
        vc.navigationController?.pushViewController(editorVC, animated: true)
    }
}

