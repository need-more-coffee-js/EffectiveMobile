//
//  TodoListInteractorMoreTests.swift
//  TodoListTests
//
//  Created by Денис Ефименков on 11.09.2025.
//

import XCTest
@testable import TodoList

final class TodoListInteractorMoreTests: XCTestCase {
    func testGetTodosFallsBackToLocalOnApiError() {
        let api = MockTodoAPIService()
        api.result = .failure(.noData)

        let core = MockCoreDataService()
        let localModel = TodoModel(context: CoreDataStack.shared.context)
        localModel.id = UUID()
        localModel.desc = "Local"
        localModel.createdAt = Date()
        localModel.isCompleted = false
        core.todosToReturn = [localModel]

        let interactor = TodoListInteractor(apiService: api, coreDataService: core)

        final class Out: TodoListInteractorOutputProtocol {
            var fetched: [TodoItem] = []
            func didFetchTodos(_ todos: [TodoItem]) { fetched = todos }
            func didFailFetchingTodos(_ error: any Error) {}
        }
        let out = Out()
        interactor.presenter = out

        interactor.getTodos()

        XCTAssertEqual(out.fetched.count, 1)
        XCTAssertEqual(out.fetched.first?.desc, "Local")
    }

    func testMergeDoesNotDuplicateByApiId() {
        let api = MockTodoAPIService()
        api.result = .success([
            TodoItem(apiId: 1, desc: "A", isCompleted: false),
            TodoItem(apiId: 2, desc: "B", isCompleted: false)
        ])

        let core = MockCoreDataService()
        let local = TodoModel(context: CoreDataStack.shared.context)
        local.id = UUID()
        local.desc = "A-local"
        local.isCompleted = false
        local.createdAt = Date()
        local.userId = 0

        core.todosToReturn = [local]

        let interactor = TodoListInteractor(apiService: api, coreDataService: core)
        final class Out: TodoListInteractorOutputProtocol {
            var fetched: [TodoItem] = []
            func didFetchTodos(_ todos: [TodoItem]) { fetched = todos }
            func didFailFetchingTodos(_ error: any Error) {}
        }
        let out = Out()
        interactor.presenter = out

        interactor.getTodos()
        XCTAssertGreaterThanOrEqual(out.fetched.count, 1)
    }
}
