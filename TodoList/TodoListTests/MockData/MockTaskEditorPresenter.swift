//
//  MockTaskEditorPresenter.swift
//  TodoListTests
//
//  Created by Денис Ефименков on 11.09.2025.
//

import XCTest
@testable import TodoList

final class MockTaskEditorPresenter: TaskEditorInteractorOutputProtocol {
    var didSaveCalled = false
    func didSaveTask() {
        didSaveCalled = true
    }
}
