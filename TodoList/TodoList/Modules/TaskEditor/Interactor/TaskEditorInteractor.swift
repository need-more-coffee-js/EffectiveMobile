//
//  InteractorView.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//
import Foundation

protocol TaskEditorInteractorProtocol: AnyObject {
    var presenter: TaskEditorInteractorOutputProtocol? { get set }
    func saveTask(id: Int?, title: String, description: String)
    func saveTask(todo: TodoItem, newTitle: String, newDescription: String, isCompleted: Bool)
}

protocol TaskEditorInteractorOutputProtocol: AnyObject {
    func didSaveTask()
}

final class TaskEditorInteractor: TaskEditorInteractorProtocol {
    weak var presenter: TaskEditorInteractorOutputProtocol?
    private let coreDataService: CoreDataServiceProtocol

    init(coreDataService: CoreDataServiceProtocol = CoreDataService()) {
        self.coreDataService = coreDataService
    }

    func saveTask(id: Int?, title: String, description: String) {
        if let id = id {
            print("заглушка для api-задач с (id: \(id))")
        } else {
            coreDataService.saveItem(title: title, description: description, isCompleted: false, uuid: nil)
            presenter?.didSaveTask()
        }
    }

    func saveTask(todo: TodoItem, newTitle: String, newDescription: String, isCompleted: Bool) {
        if let uuid = todo.uuid {
            coreDataService.updateItem(id: uuid, title: newTitle, description: newDescription, isCompleted: isCompleted)
            presenter?.didSaveTask()
        } else {
            print("заглушка для api-задач без uuid")
        }
    }
}
