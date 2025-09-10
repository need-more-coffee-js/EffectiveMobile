//
//  MockCoreDataService.swift
//  TodoListTests
//
//  Created by Денис Ефименков on 11.09.2025.
//

import Foundation
@testable import TodoList

final class MockCoreDataService: CoreDataServiceProtocol {
    var fetchCalled = false
    var saveCalled = false
    var updateCalled = false
    var deleteCalled = false

    var todosToReturn: [TodoModel] = []

    func fetch(completion: @escaping ([TodoModel]) -> Void) {
        fetchCalled = true
        completion(todosToReturn)
    }

    func saveItem(title: String, description: String?, isCompleted: Bool, uuid: UUID?, completion: (() -> Void)?) {
        saveCalled = true
        completion?()
    }

    func updateItem(id: UUID, title: String, description: String?, isCompleted: Bool, completion: (() -> Void)?) {
        updateCalled = true
        completion?()
    }

    func deleteItem(id: UUID, completion: (() -> Void)?) {
        deleteCalled = true
        completion?()
    }
}
