//
//  CoreDataService.swift
//  TodoList
//
//  Created by Денис Ефименков on 08.09.2025.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func fetch() -> [TodoModel]
    func saveItem(_ item: [TodoItem])
}

class CoreDataService: CoreDataServiceProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }
    
    func fetch() -> [TodoModel] {
        let request: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
        return(try? context.fetch(request)) ?? []
    }
    
    func saveItem(_ item: [TodoItem]){
        for todoItem in item {
            let newItem = TodoModel(context: context)
            newItem.id = UUID()
            newItem.desc = todoItem.desc
            newItem.createdAt = Date()
            newItem.isCompleted = todoItem.isCompleted
        }
        saveContext()
    }
    
    func saveContext(){
        CoreDataStack.shared.saveContext()
    }
    
}
