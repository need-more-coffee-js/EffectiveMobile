//
//  TodoAPIService.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation

protocol TodoAPIServiceProtocol {
    func fetchTodos(completion: @escaping ([TodoItem]) -> Void)
}

class TodoAPIService: TodoAPIServiceProtocol {
    func fetchTodos(completion: @escaping ([TodoItem]) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching items: \(error)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let items = try decoder.decode(TodoResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(items.todos.map { $0.toDomain() })
                }
            } catch {
                print("Error decoding: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }
}

