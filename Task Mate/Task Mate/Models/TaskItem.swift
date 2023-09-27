//
//  TaskItem.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import Foundation
import CoreData

struct TaskItem: Identifiable {

    let id: UUID
    var listID: UUID
    private(set) var title: String
    private(set) var notes: String
    private(set) var isCompleted: Bool
    private(set) var hasFlag: Bool
    private(set) var priority: ListPriority
    private(set) var completionDate: Date?
    private(set) var date: Date?
    private(set) var time: Date?
    
    /// Creates an instance of a TaskItem.
    ///
    /// - Parameters:
    ///   - title: The raw, user-inputted title of the Task.
    ///   - listID: The ListItem ID associated with the Task.
    ///   - notes: The raw, user-inputted notes of the Task.
    ///   - hasFlag: The flag value of the Task.
    ///   - priority: The priority of the Task.
    ///   - date: The year, month and weekday this Task is scheduled for.
    ///   - time: The hour and minute this Task is scheduled for.
    init(title: String, listID: UUID, notes: String, hasFlag: Bool, priority: ListPriority, date: Date? = nil, time: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.isCompleted = false
        self.completionDate = nil
        self.priority = priority
        self.hasFlag = hasFlag
        self.date = date
        self.time = time
        self.listID = listID
    }
    
    /// Creates an instance of a Task from a Core Data entity.
    ///
    /// - Parameters:
    ///   - entity: The Task instance from the Core Data store.
    init?(fromEntity entity: TaskEntity) {
        guard let entityIdentifier = entity.id, let list = entity.list, let listID = list.id else { return nil }
        
        self.id = entityIdentifier
        self.listID = listID
        self.title = entity.wrappedTitle
        self.notes = entity.wrappedNotes
        self.isCompleted = entity.isCompleted
        self.hasFlag = entity.hasFlag
        self.completionDate = entity.date
        
        if let entityPriority = entity.priority {
            self.priority = ListPriority(rawValue: entityPriority)!
        } else {
            self.priority = .whenever
        }
        
        if let entityDate = entity.date {
            self.date = entityDate
        } else {
            self.date = nil
        }
        
        if let entityDate = entity.time {
            self.time = entityDate
        } else {
            self.time = nil
        }
    
    }
    
    /// Creates a TaskEntity from the instance to be used with Core Data.
    ///
    /// - Returns:
    /// An instance of TaskEntity.
    @discardableResult
    func getEntity(context: NSManagedObjectContext, listEntity: ListEntity) -> TaskEntity {
        let entity = TaskEntity(context: context)
        
        entity.id = id
        entity.title = title
        entity.notes = notes
        entity.isCompleted = isCompleted
        entity.hasFlag = hasFlag
        entity.priority = priority.rawValue
        entity.list = listEntity
        entity.date = date
        entity.time = time
      
        return entity
    }

    /// Updates the instance's title property.
    ///
    /// - Parameters:
    ///   - newTitle: The new title to be updated.
    mutating func toogleCompletionState() {
        isCompleted.toggle()
        if !isCompleted {
            completionDate = nil
        }
    }
    
    /// Updates the instance's flag property.
    mutating func toogleFlag() {
        hasFlag.toggle()
    }
    
    /// Updates the instance's isCompleted property.
    mutating func setCompletionDate() {
        isCompleted = true
        completionDate = Date.now
    }
    
    /// Updates the instance's task properties.
    ///
    /// - Parameters:
    ///   - newTitle: The raw new, user-inputted title of the Task.
    ///   - newNotes: The raw new, user-inputted notes of the Task.
    ///   - newFlag: The new flag value of the Task.
    ///   - newPriority: The new priority of the Task.
    ///   - newDate: The new year, month and weekday this Task is scheduled for.
    ///   - newTime: The new hour and minute this Task is scheduled for.
    mutating func edit(newTitle: String, newNotes: String, newDate: Date? = nil, newTime: Date? = nil, newFlag: Bool, newPriority: String) {
        title = newTitle
        notes = newNotes
        date = newDate
        time = newTime
        hasFlag = newFlag
        priority = ListPriority(rawValue: newPriority) ?? .whenever
    }
}
