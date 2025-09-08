//
//  InteractorView.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

protocol TaskEditorInteractorProtocol {
    func saveTask(id: Int?, title: String, description: String)
}

protocol TaskEditorInteractorOutputProtocol: AnyObject {
    func didSaveTask()
}

final class TaskEditorInteractor: TaskEditorInteractorProtocol {
    weak var presenter: TaskEditorInteractorOutputProtocol?

    func saveTask(id: Int?, title: String, description: String) {
        if let id = id {
            print("обновляем задачу с id=\(id)")
        } else {
            print("создаём новую задачу с title=\(title)")
        }
        presenter?.didSaveTask()
    }
}

