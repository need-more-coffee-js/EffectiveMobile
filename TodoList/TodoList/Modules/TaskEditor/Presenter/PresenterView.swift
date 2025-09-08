//
//  PresenterView.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

protocol TaskEditorPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSave(title: String?, description: String?)
}

final class TaskEditorPresenter: TaskEditorPresenterProtocol {
    weak var view: TaskEditorViewProtocol?
    var interactor: TaskEditorInteractorProtocol?
    var router: TaskEditorRouterProtocol?

    private let task: TodoItem?

    init(task: TodoItem?) {
        self.task = task
    }

    func viewDidLoad() {
        if let task = task {
            view?.showTask(title: task.desc, description: "")
        }
    }

    func didTapSave(title: String?, description: String?) {
        interactor?.saveTask(id: task?.id, title: title ?? "", description: description ?? "")
    }
}

extension TaskEditorPresenter: TaskEditorInteractorOutputProtocol {
    func didSaveTask() {
        view?.close()
    }
}

