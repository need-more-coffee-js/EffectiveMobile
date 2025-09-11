//
//  CoreDataStack.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import CoreData

class CoreDataStack{
    static let shared = CoreDataStack()
    
    private init(){}
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreDataStack: \(error)")
            }
        }
        return container
    }()

    func saveContext() {
        guard context.hasChanges else { return }
        do { try context.save() }
        catch { print("Failed to save context: \(error)") }
    }
}
