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
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(TodoResponse.self, from: data)
                let todos = response.todos.map { $0.toDomain() }
                DispatchQueue.main.async {
                    completion(.success(todos))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}

