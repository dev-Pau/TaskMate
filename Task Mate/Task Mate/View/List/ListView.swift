//
//  ListView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import SwiftUI
import CoreData

/// A view that displays a List.
struct ListView: View {

    @ObservedObject private var viewModel: ListViewModel
    @State private var addTaskIsPresented = false
    
    /// Creates an instance of ListView.
    ///
    /// - Parameters:
    ///   - viewModel: The view model of the List.
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ListItemView(viewModel: viewModel)
    }
}

struct ListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView(viewModel: ListViewModel(for: ListItem(title: "Christmas", color: .systemPink, image: "gift.fill")))
        }
    }
}
