//
//  Model.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation
import CoreData

struct TodoItem {
    let uuid: UUID?         // core data id, если сохранено локально
    let apiId: Int?         // api id, если получено с сервера
    let desc: String
    let isCompleted: Bool
    let createdAt: Date?
    let userId: Int?
    let descriptionTask: String?
    
    init(uuid: UUID? = nil,
         apiId: Int? = nil,
         desc: String,
         isCompleted: Bool,
         createdAt: Date? = nil,
         userId: Int? = nil,
         descriptionTask: String? = nil) {
        self.uuid = uuid
        self.apiId = apiId
        self.desc = desc
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.userId = userId
        self.descriptionTask = descriptionTask
    }
}

struct TodoResponse: Codable {
    let todos: [TodoAPIDTO]
}

struct TodoAPIDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
    
    func toDomain() -> TodoItem {
        TodoItem(
            apiId: id,
            desc: todo,
            isCompleted: completed,
            createdAt: nil,
            userId: userId
        )
    }
}

extension TodoModel {
    func toDomain() -> TodoItem {
        TodoItem(
            uuid: id,
            desc: desc ?? "",
            isCompleted: isCompleted,
            createdAt: createdAt,
            userId: Int(userId),
            descriptionTask: descriptionTask
        )
    }
}




