//
//  CoreDataService.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import CoreData

protocol CoreDataServiceProtocol {
    func fetch(completion: @escaping ([TodoModel]) -> Void)
    func saveItem(title: String, description: String?, isCompleted: Bool, uuid: UUID?, completion: (() -> Void)?)
    func updateItem(id: UUID, title: String, description: String?, isCompleted: Bool, completion: (() -> Void)?)
    func deleteItem(id: UUID, completion: (() -> Void)?)
}

final class CoreDataService: CoreDataServiceProtocol {
    private let viewContext: NSManagedObjectContext
    private let backgroundContext: NSManagedObjectContext

    init(stack: CoreDataStack = .shared) {
        self.viewContext = stack.context
        self.backgroundContext = stack.persistentContainer.newBackgroundContext()
    }

    func fetch(completion: @escaping ([TodoModel]) -> Void) {
        viewContext.perform {
            let request: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            let results = (try? self.viewContext.fetch(request)) ?? []
            DispatchQueue.main.async { completion(results) }
        }
    }

    func saveItem(title: String, description: String?, isCompleted: Bool, uuid: UUID?, completion: (() -> Void)?) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            if let uuid = uuid {
                let request: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
                if let existing = try? self.backgroundContext.fetch(request).first {
                    existing.desc = title
                    existing.descriptionTask = description
                    existing.isCompleted = isCompleted
                }
            } else {
                let newItem = TodoModel(context: self.backgroundContext)
                newItem.id = UUID()
                newItem.desc = title
                newItem.descriptionTask = description
                newItem.createdAt = Date()
                newItem.isCompleted = isCompleted
            }

            self.saveContext()
            DispatchQueue.main.async { completion?() }
        }
    }

    func updateItem(id: UUID, title: String, description: String?, isCompleted: Bool, completion: (() -> Void)?) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            let request: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            if let todo = try? self.backgroundContext.fetch(request).first {
                todo.desc = title
                todo.descriptionTask = description
                todo.isCompleted = isCompleted
                self.saveContext()
            }
            DispatchQueue.main.async { completion?() }
        }
    }

    func deleteItem(id: UUID, completion: (() -> Void)?) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            let request: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            if let todo = try? self.backgroundContext.fetch(request).first {
                self.backgroundContext.delete(todo)
                self.saveContext()
            }
            DispatchQueue.main.async { completion?() }
        }
    }

    private func saveContext() {
        guard backgroundContext.hasChanges else { return }
        do {
            try backgroundContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
