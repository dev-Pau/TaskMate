//
//  TaskListView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import SwiftUI

/// A view used to display Tasks.
struct TaskView: View {
    
    @ObservedObject private var viewModel: ListViewModel
    
    private var selectedTask: TaskItem?
    
    let filters = ["Deadline", "None", "Priority", "Flag"]
    @State private var selectedFilter = "None"
    @State private var isShowingCompleted: Bool = false
    
    /// Creates an instance of TaskView.
    ///
    /// - Parameters:
    ///   - viewModel: The view model of the List.
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                if viewModel.isShowingCompleted {
                    Section {
                        HStack(alignment: .center) {
                            Text("\(viewModel.completedTasks.count) Completed  •")
                                .font(.headline)
                                .foregroundColor(.secondary)
                             
                            Menu {
                                Text("Completed Reminders")
                                Button("All Completed") { viewModel.clear() }
                            } label: {
                                Text("Clear")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Section {
                    ForEach(viewModel.tasks) { taskViewModel in
                        
                        TaskDetailView(viewModel: taskViewModel,
                                       colorTheme: Color(uiColor: self.viewModel.list.color), onAction: nil)
                        .swipeActions {
                            Button() {
                                viewModel.clear(task: taskViewModel.task)
                            } label: {
                                Text("Delete")
                            }
                            .tint(.red)
                            
                            Button() {
                                taskViewModel.toggleFlag()
                                viewModel.objectWillChange.send()
                            } label: {
                                Text(taskViewModel.task.hasFlag ? "Unflag" : "Flag")
                            }
                            .tint(.orange)
                            
                            Button() {
                                viewModel.presentEditTaskSheet(viewModel: taskViewModel)
                            } label: {
                                Text("Details")
                            }
                            .tint(.gray)
                        }
                    }
                }
                
                if viewModel.isShowingCompleted {
                    Section {
                        ForEach(viewModel.completedTasks) { taskViewModel in
                            TaskDetailView(viewModel: taskViewModel,
                                           colorTheme: Color(uiColor: self.viewModel.list.color), onAction: nil)
                            .swipeActions {
                                Button() {
                                    viewModel.clear(task: taskViewModel.task)
                                } label: {
                                    Text("Delete")
                                }
                                .tint(.red)
                                
                                Button() {
                                    taskViewModel.toggleFlag()
                                    viewModel.objectWillChange.send()
                                } label: {
                                    Text(taskViewModel.task.hasFlag ? "Unflag" : "Flag")
                                }
                                .tint(.orange)
                                
                                Button() {
                                    viewModel.presentEditTaskSheet(viewModel: taskViewModel)
                                } label: {
                                    Text("Details")
                                }
                                .tint(.gray)
                            }
                        }
                    } header: {
                        Text("Completed")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                }
            }
            .navigationBarTitle(viewModel.list.title)
            .listStyle(.plain)
            
            Button {
                viewModel.presentAddTaskSheet()
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color(uiColor: viewModel.list.color))
                    Image(systemName: "plus")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                }
                .frame(width: 40, height: 40)
                .padding()
            }
            .foregroundColor(Color(uiColor: viewModel.list.color))
        }

        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        withAnimation { viewModel.isShowingCompleted.toggle() }
                    } label: {
                        Label(viewModel.isShowingCompleted ? "Hide Complete" : "Show Complete", systemImage: viewModel.isShowingCompleted ? "eye.slash.fill" : "eye")
                    }
                } label: {
                    Label("Options", systemImage: "ellipsis.circle")
                }
            }
        }

        .sheet(isPresented: $viewModel.isAddTaskSheetPresented) {
            AddTaskView(viewModel: viewModel)
                .presentationDetents([.fraction(0.2)])
        }
        
        .sheet(isPresented: $viewModel.isEditTaskSheetPresented) {
            EditTaskView(viewModel: viewModel.selectedViewModel!)
            
        }
        
        .task {
            viewModel.loadTasks()
        }

        .onReceive(AppPublishers.refreshToDoTasksPublisher) { _ in viewModel.refreshTasks() }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskView(viewModel: ListViewModel(for: ListItem(title: "Vacation", color: .systemPink, image: "gift.fill")))
        }
    }
}


