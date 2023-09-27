//
//  DataProvider.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 6/5/23.
//

import Foundation
import CoreData

/// The data provider service used to interface with Core Data.
class DataProvider {
    
    static let shared = DataProvider()
    let persistentContainer: NSPersistentContainer
    
    /// Creates an instance of the DataProvider
    private init() {
        ValueTransformer.setValueTransformer(UIColorTransformer(), forName: NSValueTransformerName("UIColorTransformer"))
        persistentContainer = NSPersistentContainer(name: "TaskMate")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    /// Creates an instance of the DataProvider.
    ///
    /// - Parameters:
    ///   - persistentContainer: The persistent Containerto be used.
    init(for persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
}

//MARK: - Save Operations

extension DataProvider {
    
    /// Saves a given task to the Core Data store.
    ///
    /// - Parameters:
    ///   - list: The list to be saved.
    func save(list: ListItem) {
        list.getEntity(context: persistentContainer.viewContext)
        
        do {
            try persistentContainer.viewContext.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Saves a given task to a given list to the Core Data store.
    ///
    /// - Parameters:
    ///   - task: The task to be saved.
    ///   - list: The list to be saved.
    func save(task: TaskItem, for list: ListItem) {
        let request = NSFetchRequest<ListEntity>(entityName: "ListEntity")
        request.predicate = NSPredicate(format: "id == %@", list.id as CVarArg)
        
        do {
            let listEntities = try persistentContainer.viewContext.fetch(request)
            
            if let listEntity = listEntities.first {
                task.getEntity(context: persistentContainer.viewContext, listEntity: listEntity)
                try persistentContainer.viewContext.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Retrieve Operations

extension DataProvider {
    
    /// Retrieves all list items from the Core Data store.
    ///
    /// - Returns:
    /// An array of list items.
    func getLists() -> [ListItem] {
        var listEntities = [ListEntity]()
        
        let request = NSFetchRequest<ListEntity>(entityName: "ListEntity")

        do {
            listEntities = try persistentContainer.viewContext.fetch(request)
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return listEntities.compactMap { ListItem(fromEntity: $0) }
    }
    
    
    /// Retrieves all the incompleted tasks for a given list from the Core Data store.
    ///
    /// - Parameters:
    ///   - list: The list to search for.
    ///
    /// - Returns:
    /// An array of incompleted tasks.
    func getTasks(for list: ListItem) -> [TaskItem] {
        var taskEntities = [TaskEntity]()
        
        let request = NSFetchRequest<ListEntity>(entityName: "ListEntity")
        request.predicate = NSPredicate(format: "id == %@", list.id as CVarArg)
       
        do {
            let listEntities = try persistentContainer.viewContext.fetch(request)
            if let listEntity = listEntities.first {
                
                let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "list == %@", listEntity),
                                                                                        NSPredicate(format: "isCompleted == %@", NSNumber(value: false))
                                                                                       ])
                taskEntities = try persistentContainer.viewContext.fetch(request)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        return taskEntities.compactMap { TaskItem(fromEntity: $0) }
    }
    
    
    /// Retrieves all the completed tasks for a given list from the Core Data store.
    ///
    /// - Parameters:
    ///   - list: The list to search for.
    ///
    /// - Returns:
    /// An array of completed tasks.
    func getCompletedTasks(for list: ListItem) -> [TaskItem] {
        var taskEntities = [TaskEntity]()
        
        let request = NSFetchRequest<ListEntity>(entityName: "ListEntity")
        request.predicate = NSPredicate(format: "id == %@", list.id as CVarArg)
       
        do {
            let listEntities = try persistentContainer.viewContext.fetch(request)
            if let listEntity = listEntities.first {
                
                let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "list == %@", listEntity),
                                                                                        NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
                                                                                       ])
                taskEntities = try persistentContainer.viewContext.fetch(request)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return taskEntities.compactMap { TaskItem(fromEntity: $0) }
    }
    
    
    /// Retrieves the number of completed tasks from the Core Data store.
    ///
    /// - Returns:
    /// The number of completed tasks.
    func getCompletedTasks() -> Int {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
        request.resultType = .countResultType
        
        do {
            let taskEntities = try persistentContainer.viewContext.count(for: request)
            return taskEntities
            
        } catch let error {
            print(error.localizedDescription)
            return 0
        }
    }
    
    
    /// Retrieves the number of incompleted tasks from the Core Data store.
    ///
    /// - Returns:
    /// The number of incompleted tasks.
    func getPendingTasks() -> Int {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: false))
        request.resultType = .countResultType
        
        do {
            let taskEntities = try persistentContainer.viewContext.count(for: request)
            return taskEntities
            
        } catch let error {
            print(error.localizedDescription)
            return 0
        }
    }
}

//MARK: - Update Operations

extension DataProvider {
    
    /// Updates a given property for a given List within the Core Data store.
    ///
    /// - Parameters:
    ///   - list: The list to be updated.
    ///   - value: The new value to be set.
    ///   - key: The key of the property to be updated.
    func update(list: ListItem, set value: Any?, forKey key: String) {
        let request = NSFetchRequest<ListEntity>(entityName: "ListEntity")
        request.predicate = NSPredicate(format: "id == %@", list.id as CVarArg)
        
        do {
            let listEntities = try persistentContainer.viewContext.fetch(request)
            
            if let listEntity = listEntities.first {
                listEntity.setValue(value, forKey: key)
            }
            
            try persistentContainer.viewContext.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /// Updates a given property for a given Task within the Core Data store.
    ///
    /// - Parameters:
    ///   - task: The task to be updated.
    ///   - value: The new value to be set.
    ///   - key: The key of the property to be updated.
    func edit(task: TaskItem, set value: Any?, forKey key: String) {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            let taskEntities = try persistentContainer.viewContext.fetch(request)
            
            if let taskEntity = taskEntities.first {
                taskEntity.setValue(value, forKey: key)
            }
            
            try persistentContainer.viewContext.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Delete Operations

extension DataProvider {
    
    /// Deletes a given List from the Core Data store.
    ///
    /// - Parameters:
    ///   - list: The List to be deleted.
    func delete(list: ListItem) {
        let request = NSFetchRequest<ListEntity>(entityName: "ListEntity")
        request.predicate = NSPredicate(format: "id == %@", list.id as CVarArg)
        
        do {
            let listEntities = try persistentContainer.viewContext.fetch(request)
            
            if let listEntity = listEntities.first {
                persistentContainer.viewContext.delete(listEntity)
                
            }
            
            try persistentContainer.viewContext.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /// Deletes a given Task with a given List form the Core Data store.
    ///
    /// - Parameters:
    ///  - task: The Task to be deleted.
    ///  - list: The List conforming the task.
    func delete(task: TaskItem, for list: ListItem) {
        let request = NSFetchRequest<ListEntity>(entityName: "ListEntity")
        request.predicate = NSPredicate(format: "id == %@", list.id as CVarArg)
        
        do {
            let listEntities = try persistentContainer.viewContext.fetch(request)
            
            if let listEntity = listEntities.first {
                
                let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
                request.predicate = NSPredicate(format: "list == %@", listEntity)
                let taskEntities = try persistentContainer.viewContext.fetch(request)
                
                if let taskEntity = taskEntities.first {
                    persistentContainer.viewContext.delete(taskEntity)
                }
            }
            
            try persistentContainer.viewContext.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /// Deletes a given Task from the Core Data store.
    ///
    /// - Parameters:
    ///   - task: The Task to be deleted.
    func delete(task: TaskItem) {
        
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            let taskEntities = try persistentContainer.viewContext.fetch(request)
            if let taskEntity = taskEntities.first {
                persistentContainer.viewContext.delete(taskEntity)
            }
            
            try persistentContainer.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /// Deletes all the completed tasks from the Core Data store.
    ///
    /// - Parameters:
    ///   - tasks: The Task to be deleted.
    ///   - list: The parent List of the Tasks.
    func delete(tasks: [TaskItem], for list: ListItem) {
        let request = NSFetchRequest<ListEntity>(entityName: "ListEntity")
        request.predicate = NSPredicate(format: "id == %@", list.id as CVarArg)

        do {
            let listEntities = try persistentContainer.viewContext.fetch(request)
            if let listEntity = listEntities.first {
                
                let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "list == %@", listEntity),
                                                                                        NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
                                                                                       ])
                
                let taskEntities = try persistentContainer.viewContext.fetch(request)
                for taskEntity in taskEntities {
                    persistentContainer.viewContext.delete(taskEntity)
                }
                
                try persistentContainer.viewContext.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

