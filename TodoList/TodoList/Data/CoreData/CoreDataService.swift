//
//  CoreDataService.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import CoreData

protocol CoreDataServiceProtocol {
    func fetch() -> [TodoModel]
    func saveItem(title: String, description: String?, isCompleted: Bool, uuid: UUID?)
    func updateItem(id: UUID, title: String, description: String?, isCompleted: Bool)
    func deleteItem(id: UUID)
}

final class CoreDataService: CoreDataServiceProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience init() {
        self.init(context: CoreDataStack.shared.context)
    }
    
    func fetch() -> [TodoModel] {
        let request: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
    
    func saveItem(title: String, description: String?, isCompleted: Bool, uuid: UUID? = nil) {
        if let uuid = uuid, let existing = fetch().first(where: { $0.id == uuid }) {
            existing.desc = title
            existing.descriptionTask = description
            existing.isCompleted = isCompleted
        } else {
            let newItem = TodoModel(context: context)
            newItem.id = uuid ?? UUID()
            newItem.desc = title
            newItem.descriptionTask = description
            newItem.createdAt = Date()
            newItem.isCompleted = isCompleted
        }
        saveContext()
    }

    func updateItem(id: UUID, title: String, description: String?, isCompleted: Bool) {
        let request: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let todo = try? context.fetch(request).first {
            todo.desc = title
            todo.descriptionTask = description
            todo.isCompleted = isCompleted
            saveContext()
        }
    }
    
    func deleteItem(id: UUID) {
        let request: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let todo = try? context.fetch(request).first {
            context.delete(todo)
            saveContext()
        }
    }
    
    private func saveContext() {
        CoreDataStack.shared.saveContext()
    }
}
