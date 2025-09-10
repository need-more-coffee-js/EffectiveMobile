//
//  TodoListPresenterTests.swift
//  TodoListTests
//
//  Created by Денис Ефименков on 11.09.2025.
//

import XCTest
@testable import TodoList

final class TodoListPresenterTests: XCTestCase {

    var presenter: TodoListPresenter!
    var mockView: MockTodoListView!
    var mockInteractor: MockTodoListInteractor!

    override func setUp() {
        super.setUp()
        presenter = TodoListPresenter()
        mockView = MockTodoListView()
        mockInteractor = MockTodoListInteractor()
        presenter.view = mockView
        presenter.interactor = mockInteractor
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        super.tearDown()
    }

    func testDidFetchTodosFiltersCorrectly() {
        let todo1 = TodoItem(desc: "Test1", isCompleted: false)
        let todo2 = TodoItem(desc: "Another", isCompleted: false)
        presenter.didFetchTodos([todo1, todo2])
        presenter.didSearch(text: "test")
        XCTAssertEqual(presenter.todos.count, 1)
        XCTAssertEqual(presenter.todos.first?.desc, "Test1")
    }
}

// MARK: - mock View & Interactor
final class MockTodoListView: TodoListViewProtocol {
    var presenter: TodoListPresenterProtocol?
    var todosShown: [TodoItem] = []

    func showTodos(_ todos: [TodoItem]) {
        todosShown = todos
    }

    func showError(_ error: Error) {}
}

final class MockTodoListInteractor: TodoListInteractorProtocol {
    var presenter: TodoListInteractorOutputProtocol?

    func getTodos() {}
    func delete(todo: TodoItem) {}
    func toggleCompleted(todo: TodoItem) {}
}










