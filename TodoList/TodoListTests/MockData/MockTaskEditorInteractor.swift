//
//  MockTaskEditorInteractor.swift
//  TodoListTests
//
//  Created by Денис Ефименков on 11.09.2025.
//

import XCTest
@testable import TodoList

final class MockTaskEditorInteractor: TaskEditorInteractorProtocol {
    var presenter: TaskEditorInteractorOutputProtocol?
    var saveCalled = false

    func saveTask(id: Int?, title: String, description: String) {
        saveCalled = true
    }
    func saveTask(todo: TodoItem, newTitle: String, newDescription: String, isCompleted: Bool) {
        saveCalled = true
    }
}
