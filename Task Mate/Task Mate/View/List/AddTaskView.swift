//
//  AddQuickTaskView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 8/5/23.
//

import SwiftUI

/// A view used to add a new Task.
struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var viewModel: ListViewModel
    
    @State private var title = ""

    /// Creates an instance of AddTaskView.
    ///
    /// - Parameters:
    ///   - viewModel: The view model of the List.
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Title", text: $title)
                }
            }
            .scrollDisabled(true)
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { addTask() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    func addTask() {
        viewModel.add(task: TaskItem(title: title, listID: viewModel.list.id, notes: String(), hasFlag: false, priority: .whenever))
        dismiss()
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(viewModel: ListViewModel(for: ListItem(title: "Christmas", color: .systemPink, image: "gift.fill")))
    }
}
