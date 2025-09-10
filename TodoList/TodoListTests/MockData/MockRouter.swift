//
//  MockRouter.swift
//  TodoListTests
//
//  Created by Денис Ефименков on 11.09.2025.
//

import XCTest
@testable import TodoList

final class MockRouter: TaskEditorRouterProtocol {
    var dismissCalled = false
    func dismiss() {
        dismissCalled = true
    }
}
