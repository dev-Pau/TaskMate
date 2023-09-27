//
//  ListItemView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import SwiftUI

/// The detailed view used to represent a List.
struct ListItemView: View {
    
    @ObservedObject private var viewModel: ListViewModel
    
    /// Creates an instance of the ListItem view.
    ///
    /// - Parameters:
    ///   - viewModel: The viewmodel of the List.
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundColor(Color(uiColor: viewModel.list.color))
                    .frame(width: 30, height: 30)
                Image(systemName: viewModel.list.image)
                    .foregroundColor(.white)
            }
            
            Text(viewModel.list.title)
                .padding(.leading)
            Spacer()
            Text("\(viewModel.tasks.count)")
              .foregroundColor(.secondary)
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(viewModel: ListViewModel(for: ListItem(title: "Christimas", color: .systemPink, image: "gift.fill")))
    }
}
