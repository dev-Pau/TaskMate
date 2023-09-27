//
//  HomeViewModel.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import Foundation
import SwiftUI

/// The view model for the ListView.
class ListViewModel: ObservableObject, Identifiable {

    @Published private(set) var list: ListItem
   
    @Published private(set) var tasks = [TaskViewModel]()
    @Published private(set) var completedTasks = [TaskViewModel]()
    
    @Published var isAddTaskSheetPresented = false
    @Published var isEditTaskSheetPresented = false
    @Published var isShowingCompleted = false {
        didSet {
            if isShowingCompleted { loadCompletedTasks() }
        }
    }
    
    @Published private(set) var selectedViewModel: TaskViewModel?

    /// Creates an instance of the ListViewModel and then loads the user's tasks.
    /// - Parameters:
    ///   - ListItem: The parent list that may contain multiple tasks.
    init(for list: ListItem) {
        self.list = list
        loadTasks()
    }
}

//MARK: - List Operations

extension ListViewModel {
    
    /// Loads the user's pending Tasks from the Core Data store and then sorts them.
    func loadTasks() {
        tasks = DataProvider.shared.getTasks(for: list).map { TaskViewModel(for: $0) }
        sortTasks()
    }
    
    /// Loads the user's completed Tasks from the Core Data store and then sorts them.
    func loadCompletedTasks() {
        completedTasks = DataProvider.shared.getCompletedTasks(for: list).map { TaskViewModel(for: $0)}
        sortCompletedTasks()
    }
    
    /// Refresh the tasks after any data change.
    func refreshTasks() {
        if let completedTask = tasks.first(where: { $0.task.isCompleted == true }) {
            if isShowingCompleted {
                completedTasks.append(completedTask)
                sortCompletedTasks()
            }
            
            withAnimation {
                tasks.removeAll(where: { $0.task.isCompleted == true })
            }
        }
        
        if let pendingTask = completedTasks.first(where: { $0.task.isCompleted == false }) {
            tasks.append(pendingTask)
            sortTasks()
            withAnimation {
                completedTasks.removeAll(where: { $0.task.isCompleted == false })
            }
        }
    }
    
    /// Edits some list changes to the Core Data store and the view model.
    ///
    /// - Parameters:
    ///   - newTitle: The new title to be updated.
    ///   - newColor: The new color value to be updated.
    ///   - newImage: The new image value to be updated.
    func edit(newTitle: String, newColor: UIColor, newImage: String) {
        DataProvider.shared.update(list: list, set: newTitle, forKey: "title")
        DataProvider.shared.update(list: list, set: newColor, forKey: "color")
        DataProvider.shared.update(list: list, set: newImage, forKey: "image")
        
        NotificationCenter.default.post(name: Notification.Name(AppPublishers.Names.refreshLists), object: nil)
    }
    
    /// Deletes a task from the Core Data store and the view model.
    ///
    /// - Parameters:
    ///   - task: The task to be cleared.
    func clear(task: TaskItem) {
        DataProvider.shared.delete(task: task, for: list)
        withAnimation {
            tasks.removeAll(where: { $0.task.id == task.id })
        }
    }
    
    /// Deletes all completed from the Core Data store and the view model.
    func clear() {
        guard !completedTasks.isEmpty else { return }
        let tasks = completedTasks.map { $0.task }
        DataProvider.shared.delete(tasks: tasks, for: list)
        completedTasks.removeAll()
    }
    
    /// Presents the AddTaskView.
    func presentAddTaskSheet() {
        clearSelectedTask()
        isAddTaskSheetPresented = true
    }
    
    /// Presents the EditTaskView.
    ///
    /// - Parameters:
    ///   - viewModel: The view model of the task to be edited.
    func presentEditTaskSheet(viewModel: TaskViewModel) {
        selectedViewModel = viewModel
        isEditTaskSheetPresented = true
    }
    
    /// Adds a new task to the Core Data store and the view model.
    ///
    /// - Parameters:
    ///   - task: The task to be added.
    func add(task: TaskItem) {
        DataProvider.shared.save(task: task, for: list)
        withAnimation {
            tasks.append(TaskViewModel(for: task))
            sortTasks()
        }
    }
    
    /// Sort tasks by date and title.
    private func sortTasks() {
        tasks.sort { task1, task2 in
            if task1.task.date ?? nil != task2.task.date ?? nil {
                return task1.task.date ?? Date() < task2.task.date ?? Date()
            } else {
                return task1.task.title < task2.task.title
            }
        }
    }
    
    /// Sort completed tasks by date and title.
    private func sortCompletedTasks() {
        completedTasks.sort { task1, task2 in
            if task1.task.date ?? Date.now != task2.task.date {
                return task1.task.date ?? Date.now < task2.task.date ?? Date.now
            } else {
                return task1.task.title < task2.task.title
            }
        }
        
    }
    
    /// Removes the reference to the view model selected.
    func clearSelectedTask() {
        selectedViewModel = nil
    }
}
