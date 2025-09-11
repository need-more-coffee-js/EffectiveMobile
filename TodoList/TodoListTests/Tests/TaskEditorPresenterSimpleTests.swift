//
//  TaskEditorPresenterSimpleTests.swift
//  TodoListTests
//
//  Created by Денис Ефименков on 11.09.2025.
//

import XCTest
@testable import TodoList

final class TaskEditorPresenterSimpleTests: XCTestCase {
    func testDidTapSaveWithEmptyTitleDoesNothing() {
        let presenter = TaskEditorPresenter(task: nil)
        let interactor = MockTaskEditorInteractor()
        presenter.interactor = interactor

        presenter.didTapSave(title: "", description: "desc")
        XCTAssertFalse(interactor.saveCalled)
    }

    func testDidTapSaveWithTitleCallsInteractor() {
        let presenter = TaskEditorPresenter(task: nil)
        let interactor = MockTaskEditorInteractor()
        presenter.interactor = interactor

        presenter.didTapSave(title: "Title", description: "desc")
        XCTAssertTrue(interactor.saveCalled)
    }
}
