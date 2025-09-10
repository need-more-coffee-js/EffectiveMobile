//
//  MockForTest.swift
//  TodoListTests
//
//  Created by Денис Ефименков on 10.09.2025.
//

import Foundation
@testable import TodoList
import CoreData
// mock для тестов
// 1. core data service
// 2. api service
// 3. presenter + interactor


// MARK: - cd mock
final class CoreDataServiceMock: CoreDataServiceProtocol {
    var didSaveCalled = false
    var didUpdateCalled = false
    var didDeleteCalled = false
    
    func fetch() -> [TodoModel] { [] }
    func saveItem(title: String, description: String?, isCompleted: Bool, uuid: UUID?) {
        didSaveCalled = true
    }
    func updateItem(id: UUID, title: String, description: String?, isCompleted: Bool) {
        didUpdateCalled = true
    }
    func deleteItem(id: UUID) {
        didDeleteCalled = true
    }
}

// MARK: - ap i mock
final class TodoAPIServiceMock: TodoAPIServiceProtocol {
    var todos: [TodoItem] = []
    func fetchTodos(completion: @escaping ([TodoItem]) -> Void) {
        completion(todos)
    }
}

// MARK: - presenter & interactor mock
final class TaskEditorPresenterMock: TaskEditorInteractorOutputProtocol {
    var didSaveCalled = false
    func didSaveTask() {
        didSaveCalled = true
    }
}

final class TodoListPresenterMock: TodoListInteractorOutputProtocol {
    var todos: [TodoItem] = []
    var error: Error?
    func didFetchTodos(_ todos: [TodoItem]) {
        self.todos = todos
    }
    func didFailFetchingTodos(_ error: Error) {
        self.error = error
    }
}

