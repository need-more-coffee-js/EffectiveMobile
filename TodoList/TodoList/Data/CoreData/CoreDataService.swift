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

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func fetch() -> [TodoModel] {
        var results: [TodoModel] = []
        context.performAndWait { 
            let request: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            results = (try? context.fetch(request)) ?? []
        }
        return results
    }

    func saveItem(title: String, description: String?, isCompleted: Bool, uuid: UUID? = nil) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.context.perform {
                if let uuid = uuid, let existing = self.fetch().first(where: { $0.id == uuid }) {
                    existing.desc = title
                    existing.descriptionTask = description
                    existing.isCompleted = isCompleted
                } else {
                    let newItem = TodoModel(context: self.context)
                    newItem.id = uuid ?? UUID()
                    newItem.desc = title
                    newItem.descriptionTask = description
                    newItem.createdAt = Date()
                    newItem.isCompleted = isCompleted
                }
                self.saveContext()
            }
        }
    }

    func updateItem(id: UUID, title: String, description: String?, isCompleted: Bool) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.context.perform {
                let request: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

                if let todo = try? self.context.fetch(request).first {
                    todo.desc = title
                    todo.descriptionTask = description
                    todo.isCompleted = isCompleted
                    self.saveContext()
                }
            }
        }
    }
    
    func deleteItem(id: UUID) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.context.perform {
                let request: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

                if let todo = try? self.context.fetch(request).first {
                    self.context.delete(todo)
                    self.saveContext()
                }
            }
        }
    }
    
    private func saveContext() {
        context.perform {
            if self.context.hasChanges {
                do {
                    try self.context.save()
                } catch {
                    print("Failed to save context: \(error)")
                }
            }
        }
    }
}
