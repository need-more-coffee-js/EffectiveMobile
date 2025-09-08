//
//  Model.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation

struct TodoResponse: Codable {
    let todos: [TodoItem]
}

struct TodoItem: Codable {
    let id: Int
    let desc: String
    let isCompleted: Bool
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case desc = "todo"
        case isCompleted = "completed"
        case createdAt
    }
}

