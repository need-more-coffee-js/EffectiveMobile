//
//  PresenterView.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//
import Foundation

protocol TaskEditorPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSave(title: String?, description: String?)
}

final class TaskEditorPresenter: TaskEditorPresenterProtocol {
    weak var view: TaskEditorViewProtocol?
    var interactor: TaskEditorInteractorProtocol?
    var router: TaskEditorRouterProtocol?
    
    private let task: TodoItem?
    
    init(task: TodoItem? = nil) {
        self.task = task
    }
    
    func viewDidLoad() {
        if let task = task {
            view?.showTask(title: task.desc, description: "")
        }
    }
    
    func didTapSave(title: String?, description: String?) {
        guard let title = title, !title.isEmpty else { return }
        
        switch task {
        case let task? where task.uuid != nil:
            interactor?.saveTask(todo: task, newTitle: title, isCompleted: task.isCompleted)
        case let task?:
            interactor?.saveTask(id: task.apiId, title: title, description: description ?? "")
        case nil:
            interactor?.saveTask(id: nil, title: title, description: description ?? "")
        }
    }

}

extension TaskEditorPresenter: TaskEditorInteractorOutputProtocol {
    func didSaveTask() {
        router?.dismiss()
    }
}

