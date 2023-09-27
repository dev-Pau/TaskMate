//
//  AddListView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 6/5/23.
//

import SwiftUI

/// A view where a list can be added by a user inputted title, color theme and a string describing an SFSymbols Image.
struct AddListView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject private var viewModel: HomeViewModel
    
    @State var color: Color = .blue
    @State var title: String = ""
    @State var image: String = "list.bullet"
    
    /// Creates an instance of AddListView.
    ///
    /// - Parameters:
    ///   - viewModel: The view model of the Home.
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
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
            
            .navigationTitle("New List")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { addList() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Dismiss") { dismiss() }
                }
            }
        }
    }
    
    /// Adds a given list after checking if the title is empty.
    private func addList() {
        viewModel.add(list: ListItem(title: title, color: UIColor(color), image: image))
        dismiss()
    }
}
