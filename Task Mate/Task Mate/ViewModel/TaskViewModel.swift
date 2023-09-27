//
//  TaskViewModel.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import SwiftUI

/// The view model for the Task.
class TaskViewModel: ObservableObject, Identifiable {
    
    @Published private(set) var task: TaskItem

    /// Creates an instance of the TaskViewModel.
    /// - Parameters:
    ///   - TaskItem: The hcorresponding task for the view model.
    init(for task: TaskItem) {
        self.task = task
    }
}

//MARK: - Functionality

extension TaskViewModel {
    
    /// Saves any task changes to the Core Data store and the view model.
    ///
    /// - Parameters:
    ///   - newTitle: The new title to be updated.
    ///   - newNotes: The new urgency value to be updated.
    ///   - newDate: The new date to be updated.
    ///   - newTime: The new time to be updated.
    ///   - newFlag: The new flag value to be updated.
    ///   - newPriority: The new priority to be updated.
    func edit(newTitle: String, newNotes: String, newDate: Date? = nil, newTime: Date? = nil, newFlag: Bool, newPriority: String) {
        DataProvider.shared.edit(task: task, set: newTitle, forKey: "title")
        DataProvider.shared.edit(task: task, set: newNotes, forKey: "notes")
        DataProvider.shared.edit(task: task, set: newDate, forKey: "date")
        DataProvider.shared.edit(task: task, set: newTime, forKey: "time")
        DataProvider.shared.edit(task: task, set: newFlag, forKey: "hasFlag")
        DataProvider.shared.edit(task: task, set: newPriority, forKey: "priority")
        task.edit(newTitle: newTitle, newNotes: newNotes, newDate: newDate, newTime: newTime, newFlag: newFlag, newPriority: newPriority)
    }
    
    /// Marks a task to complete and save it's changes to the Core Data store and the view model.
    func markAsComplete() {
        task.toogleCompletionState()
        DataProvider.shared.edit(task: task, set: true, forKey: "isCompleted")
        DataProvider.shared.edit(task: task, set: Date(), forKey: "completionDate")
        task.setCompletionDate()
        NotificationCenter.default.post(name: Notification.Name(AppPublishers.Names.refreshTasks), object: nil)
    }
    
    /// Marks a task to incomplete and save it's changes to the Core Data store and the view model.
    func markAsIncomplete() {
        task.toogleCompletionState()
        DataProvider.shared.edit(task: task, set: false, forKey: "isCompleted")
        DataProvider.shared.edit(task: task, set: nil, forKey: "completionDate")
        NotificationCenter.default.post(name: Notification.Name(AppPublishers.Names.refreshTasks), object: nil)
    }
    
    /// Toggles the value of the task's flag and save it's changes to the Core Data store and the view model.
    func toggleFlag() {
        task.toogleFlag()
        DataProvider.shared.edit(task: task, set: task.hasFlag, forKey: "hasFlag")
    }
    
    /// Deletes the task from the Core Data store and the view model.
    func clear() {
        DataProvider.shared.delete(task: task)
    }
}
