//
//  RouterView.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//
import UIKit

protocol TaskEditorRouterProtocol: AnyObject {
    func dismiss()
}

final class TaskEditorRouter: TaskEditorRouterProtocol {
    weak var viewController: UIViewController?
    var onSave: (() -> Void)?

    static func start(with task: TodoItem?, onSave: (() -> Void)? = nil) -> UIViewController {
        let view = TaskEditorViewController()
        let presenter = TaskEditorPresenter(task: task)
        let interactor = TaskEditorInteractor()
        let router = TaskEditorRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        router.onSave = onSave

        return view
    }

    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
        onSave?()
    }
}

