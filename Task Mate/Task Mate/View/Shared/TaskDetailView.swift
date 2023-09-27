//
//  TaskDetailView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import SwiftUI

/// The detailed view used to represent a Task.
struct TaskDetailView: View {
    
    @ObservedObject private var viewModel: TaskViewModel
    private let colorTheme: Color
    
    let onAction: ((Bool) -> Void)?
    
    /// Creates an instance of the TaskDetail view.
    ///
    /// - Parameters:
    ///   - viewModel: The viewmodel of the Task.
    ///   - colorTheme: The theme used to represent the Task according to its List.
    ///   - onAction: The callback function to be triggered when the user taps on the Task.
    init(viewModel: TaskViewModel, colorTheme: Color, onAction: ((Bool)->Void)? = nil) {
        self.viewModel = viewModel
        self.colorTheme = colorTheme
        self.onAction = onAction
    }

    var body: some View {
        Group {
            HStack(alignment: .top) {
                Image(systemName: viewModel.task.isCompleted ? "circle.inset.filled" : "circle")
                    .foregroundColor(viewModel.task.isCompleted ? colorTheme : .secondary)
                    .font(.title2)
                    .onTapGesture {
                        viewModel.task.isCompleted ? viewModel.markAsIncomplete() : viewModel.markAsComplete()
                        (onAction)?(true)
                    }
                
                if viewModel.task.priority != .whenever {
                    Text(viewModel.task.priority.title)
                        .foregroundColor(colorTheme)
                }
               
                VStack(alignment: .leading) {
                    Text(viewModel.task.title)
                        .padding(.top,  viewModel.task.priority != .whenever ? 0 : 2)
                    if !viewModel.task.notes.isEmpty {
                        Text(viewModel.task.notes)
                            .foregroundColor(.secondary)
                    }

                    if let date = viewModel.task.date {
                        HStack {
                            Text(date, format: .dateTime.year().day().month())
                            if let time = viewModel.task.time {
                                Text("·")
                                Text(time, format: .dateTime.hour().minute())
                            }
                        }
                        .foregroundColor(dateColorFor(viewModel.task.date, viewModel.task.time))
                    }
                }

                Spacer()
                if viewModel.task.hasFlag {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.orange)
                }
            }
            .ignoresSafeArea()
        }
    }
    
    func dateColorFor(_ date: Date?, _ time: Date?) -> Color {
        guard let date = date else { return .secondary }
        
        let calendar = Calendar.current
        let now = Date.now
        
        if date.isToday {
            guard let time = time else { return .secondary }
            // Get the hour and minute components of the current time
            let components = calendar.dateComponents([.hour, .minute], from: now)
            guard let currentHour = components.hour, let currentMinute = components.minute,
                  let targetHour = calendar.dateComponents([.hour, .minute], from: time).hour,
                  let targetMinute = calendar.dateComponents([.hour, .minute], from: time).minute
            else { return .secondary }
            
            // Check if the target time is in the past or future compared to the current time
            if targetHour < currentHour || (targetHour == currentHour && targetMinute < currentMinute) {
                return .red
            } else {
                return .secondary
            }
        } else {
            return date < now ? .red : .secondary
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskDetailView(viewModel: TaskViewModel(for: TaskItem(title: "Buy Gift", listID: UUID(), notes: String(), hasFlag: true, priority: .whenever, date: nil, time: nil)), colorTheme: .pink)
                .navigationTitle("Supermarket")
        }
    }
}
