//
//  ContentView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 6/5/23.
//

import SwiftUI
import CoreData

/// The root view of the App.
struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @State private var searchedText = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.lists) { viewModel in
                        NavigationLink {
                            TaskView(viewModel: viewModel)
                            
                        } label: {
                            ListView(viewModel: viewModel)
                                .swipeActions {
                                    Button {
                                        self.viewModel.presentDeleteListAlert(list: viewModel.list)
                                    } label: {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                    .tint(.red)
                                    
                                    Button {
                                        self.viewModel.presentEditListView(list: viewModel.list)
                                    } label: {
                                        Label("Edit", systemImage: "info.circle.fill")
                                    }
                                    .tint(.gray)
                                }
                        }
                    }
                } header: {
                    Text("My Lists")
                }
            }
            
            .navigationTitle(viewModel.weekDay)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(viewModel.dayAndMonth)
                        .font(.title2)
                        .fontWeight(.medium)
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button("Add List") { viewModel.presentAddNewList() }
                }
            }
            .sheet(isPresented: $viewModel.isAddNewListViewPresented) {
                AddListView(viewModel: viewModel)
            }
            
            .sheet(isPresented: $viewModel.isAddListSheetPresented) {
                EditListView(viewModel: ListViewModel(for: viewModel.selectedList!))
            }
            
            
            .sheet(isPresented: $viewModel.isAddTaskSheetPresented) {
                //AddTaskView(viewModel: viewModel)
            }
            
            .alert("Delete List", isPresented: $viewModel.isDeleteListAlertPresented) {
                Button("Delete", role: .destructive) {
                    viewModel.clear()
                }
                
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will delete all reminders in this list.")
            }
            
            .onAppear() {
                viewModel.getCompletedTasks()
                viewModel.getPendingTasks()
                viewModel.loadLists() 
            }
        }
        
        .task {
            viewModel.getCurrentDate()
        }
        .onReceive(AppPublishers.refreshToDoListPublisher) { _ in viewModel.loadLists() }
    }
}
