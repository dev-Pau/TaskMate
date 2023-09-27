//
//  EditListView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import SwiftUI

/// A view used to edit a given List.
struct EditListView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject private var viewModel: ListViewModel
    
    @State private var color: Color = .blue
    @State private var title: String = ""
    @State private var image: String = "list.bullet"
    
    /// Creates an instance of EditListView.
    ///
    /// - Parameters:
    ///   - viewModel: The view model of the List.
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        self._color = State(initialValue: Color(uiColor: viewModel.list.color))
        self._image = State(initialValue: viewModel.list.image)
        self._title = State(initialValue: viewModel.list.title)
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    TitlePickerView(title: $title, color: $color, image: $image)
                }
                
                Section {
                    ColorPickerView(selectedColor: $color)
                }
                
                Section {
                    ImagePickerView(selectedImage: $image)
                }
            }
            
            .navigationTitle("Edit List")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { editList() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Dismiss") { dismiss() }
                }
            }
        }
    }
    
    /// Adds a given list after checking if the title is empty.
    private func editList() {
        viewModel.edit(newTitle: title, newColor: UIColor(color), newImage: image)
        dismiss()
    }
}

struct EditListView_Previews: PreviewProvider {
    static var previews: some View {
        EditListView(viewModel: ListViewModel(for: ListItem(title: "Christmas", color: .systemPink, image: "gift.fill")))
    }
}
