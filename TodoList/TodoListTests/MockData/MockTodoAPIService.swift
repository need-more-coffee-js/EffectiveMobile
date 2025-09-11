//
//  MockTodoAPIService.swift
//  TodoListTests
//
//  Created by Денис Ефименков on 11.09.2025.
//

import XCTest
@testable import TodoList

final class MockTodoAPIService: TodoAPIServiceProtocol {
    var result: Result<[TodoItem], TodoAPIError> = .success([])
    func fetchTodos(completion: @escaping (Result<[TodoItem], TodoAPIError>) -> Void) {
        completion(result)
    }
}
