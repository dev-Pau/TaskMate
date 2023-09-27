//
//  HomeViewModel.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import Foundation
import SwiftUI

/// The view model for the ListView.
class HomeViewModel: ObservableObject {
    
    @Published private(set) var lists = [ListViewModel]()
    @Published var isAddNewListViewPresented = false
    
    @Published var isDeleteListAlertPresented = false
    @Published var isAddTaskSheetPresented = false
    @Published var isAddListSheetPresented = false
    @Published var weekDay: String = ""
    @Published var dayAndMonth: String = ""
    @Published var completedTasks: Int = 0
    @Published var pendingTasks: Int = 0
    
    @Published private(set) var selectedList: ListItem?
    
    /// Creates an instance of the HomeViewModel and then loads the user0s Lists.
    init() {
        loadLists()
        getCompletedTasks()
        getPendingTasks()
    }
}

//MARK: - Home Operations

extension HomeViewModel {
    
    /// Loads the user's Lists from the Core Data store.
    func loadLists() {
        lists = DataProvider.shared.getLists().map { ListViewModel(for: $0) }
        lists.forEach { list in
            list.loadTasks()
        }
        
        sortLists()
    }
    
    /// Adds a given List to the Core Data store and the view model and then sorts them.
    ///
    /// - Parameters:
    ///   - ListItem: The List to be added.
    func add(list: ListItem) {
        DataProvider.shared.save(list: list)
        
        withAnimation {
            lists.append(ListViewModel(for: list))
            sortLists()
        }
    }
    
    /// Removes a given List to the Core Data store and the view model.
    func clear() {
        guard let selectedList = selectedList else { return }
        DataProvider.shared.delete(list: selectedList)
        withAnimation {
            lists.removeAll(where: { $0.list.id == selectedList.id })
        }
    }
}

//MARK: - Miscellaneous Functionality

extension HomeViewModel {
    
    /// Presents the Delete List Alert
    ///
    /// - Parameters:
    ///   - ListItem: The List to be presented.
    func presentDeleteListAlert(list: ListItem) {
        selectedList = list
        isDeleteListAlertPresented = true
    }
    
    /// Presents the Delete List Alert
    ///
    /// - Parameters:
    ///   - ListItem: The List to be presented.
    func presentEditListView(list: ListItem) {
        selectedList = list
        isAddListSheetPresented = true
    }
    
    /// Presents the AddTaskView.
    func presentAddTaskView() {
        isAddTaskSheetPresented = true
    }
    
    /// Presents the AddListView.
    func presentAddNewList() {
        isAddNewListViewPresented = true
    }
    
    /// Gets all the completed Tasks from the Core Data store.
    func getCompletedTasks() {
        completedTasks = DataProvider.shared.getCompletedTasks()
    }
    
    /// Gets all the pending Tasks from the Core Data store.
    func getPendingTasks() {
        pendingTasks = DataProvider.shared.getPendingTasks()
    }
    
    /// Gets the current date, mont & week day.
    func getCurrentDate() {
        let today = Date.now
        weekDay = today.formatted(.dateTime.weekday(.abbreviated))
        dayAndMonth = today.formatted(.dateTime.day().month(.wide))
    }
}


// MARK: - Private Functionality

extension HomeViewModel {
    
    /// Sorts the loaded Lists items by title.
    private func sortLists() {
        lists.sort(by: { $0.list.title > $1.list.title })
    }
}
