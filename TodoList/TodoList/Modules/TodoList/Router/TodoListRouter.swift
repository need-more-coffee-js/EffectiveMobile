//
//  Router.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation
import UIKit

protocol TodoListRouterProtocol: AnyObject {
    func openTaskEditor(onSave: (() -> Void)?)
    func openTaskEditor(with todo: TodoItem, onSave: (() -> Void)?)
}

final class TodoListRouter: TodoListRouterProtocol {
    weak var viewController: UIViewController?

    static func start() -> UIViewController {
        let view = TodoListViewController()
        let presenter = TodoListPresenter()
        let interactor = TodoListInteractor()
        let router = TodoListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

    func openTaskEditor(onSave: (() -> Void)?) {
        let editorVC = TaskEditorRouter.start(with: nil, onSave: onSave)
        viewController?.navigationController?.pushViewController(editorVC, animated: true)
    }
    
    func openTaskEditor(with todo: TodoItem, onSave: (() -> Void)?) {
        let editorVC = TaskEditorRouter.start(with: todo, onSave: onSave)
        viewController?.navigationController?.pushViewController(editorVC, animated: true)
    }

}


