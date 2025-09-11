//
//  TodoAPIService.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation

enum TodoAPIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Неверный URL"
        case .noData: return "Данные не получены"
        case .decodingError(let error): return "Ошибка декодирования: \(error.localizedDescription)"
        case .networkError(let error): return "Сетевая ошибка: \(error.localizedDescription)"
        }
    }
}

protocol TodoAPIServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoItem], TodoAPIError>) -> Void)
}

class TodoAPIService: TodoAPIServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoItem], TodoAPIError>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            DispatchQueue.main.async { completion(.failure(.invalidURL)) }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            func finish(_ result: Result<[TodoItem], TodoAPIError>) {
                DispatchQueue.main.async { completion(result) }
            }

            if let error = error {
                return finish(.failure(.networkError(error)))
            }
            guard let data = data else {
                return finish(.failure(.noData))
            }

            do {
                let response = try JSONDecoder().decode(TodoResponse.self, from: data)
                let todos = response.todos.map { $0.toDomain() }
                finish(.success(todos))
            } catch {
                finish(.failure(.decodingError(error)))
            }
        }.resume()
    }
}

