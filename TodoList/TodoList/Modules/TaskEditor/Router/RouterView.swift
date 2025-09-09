//
//  RouterView.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//
import UIKit

protocol TaskEditorRouterProtocol {
    func dismiss()
}

final class TaskEditorRouter: TaskEditorRouterProtocol {
    func dismiss() {
        if let view = view as? UIViewController {
            view.navigationController?.popViewController(animated: true)
        }
    }
    
    weak var view: TaskEditorViewProtocol?

    static func start(with task: TodoItem?) -> UIViewController {
        let view = TaskEditorViewController()
        let presenter = TaskEditorPresenter(task: task)
        let interactor = TaskEditorInteractor()
        let router = TaskEditorRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.view = view

        return view
    }
}
