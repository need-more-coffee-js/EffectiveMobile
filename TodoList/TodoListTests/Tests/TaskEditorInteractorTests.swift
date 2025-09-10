//
//  TaskEditorInteractorTests.swift
//  TodoListTests
//
//  Created by Денис Ефименков on 11.09.2025.
//

import XCTest
@testable import TodoList

final class TaskEditorInteractorTests: XCTestCase {

    var interactor: TaskEditorInteractor!
    var mockCoreDataService: MockCoreDataService!
    var mockPresenter: MockTaskEditorPresenter!

    override func setUp() {
        super.setUp()
        mockCoreDataService = MockCoreDataService()
        interactor = TaskEditorInteractor(coreDataService: mockCoreDataService)
        mockPresenter = MockTaskEditorPresenter()
        interactor.presenter = mockPresenter
    }

    override func tearDown() {
        interactor = nil
        mockCoreDataService = nil
        mockPresenter = nil
        super.tearDown()
    }

    func testSaveTaskWithoutIDCallsSave() {
        interactor.saveTask(id: nil, title: "NewTask", description: "Description")
        XCTAssertTrue(mockCoreDataService.saveCalled)
    }

    func testSaveTaskWithTodoCallsUpdate() {
        let todo = TodoItem(uuid: UUID(), desc: "Task", isCompleted: false)
        interactor.saveTask(todo: todo, newTitle: "Updated", newDescription: "Updated", isCompleted: true)
        XCTAssertTrue(mockCoreDataService.updateCalled)
    }
}
