//
//  AddTaskView.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import SwiftUI
import UserNotifications

/// A view used to edit a given Task.
struct EditTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: TaskViewModel
    
    
    @State private var title: String
    @State private var notes = ""
    @State private var dateToogleIsOn = false
    @State private var timeToogleIsOn = false
    @State private var dateSelected = Date.now
    @State private var timeSelected = Date.now
    
    @State private var flagToogleIsOn = false
    @State private var priority = "whenever"
    
    /// Creates an instance of EditTaskView.
    ///
    /// - Parameters:
    ///   - viewModel: The view model of the Task.
    init(viewModel: TaskViewModel) {
        self.viewModel = viewModel
        _title = .init(initialValue: viewModel.task.title)
        _notes = .init(initialValue: viewModel.task.notes)
        _dateToogleIsOn = .init(initialValue: viewModel.task.date != nil ? true : false)
        _timeToogleIsOn = .init(initialValue: viewModel.task.time != nil ? true : false)
        _dateSelected = .init(initialValue: viewModel.task.date ?? Date.now)
        _timeSelected = .init(initialValue: viewModel.task.time ?? Date.now)
        _flagToogleIsOn = .init(initialValue: viewModel.task.hasFlag)
        _priority = .init(initialValue: viewModel.task.priority.rawValue)
    }
    
    let priorities = ListPriority.allCases.map { $0.rawValue }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Title", text: $title)
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $notes)
                            .frame(minHeight: 100, maxHeight: 190)
                        if notes.isEmpty {
                            Text("Notes")
                                .padding(.top, 8)
                                .padding(.leading, 2)
                                .foregroundColor(.black.opacity(0.25))
                                .allowsHitTesting(false)
                        }
                    }
                }
                Section {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .foregroundColor(.pink)
                                .frame(width: 30, height: 30)
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Calendar")
                            if dateToogleIsOn {
                                Text(dateSelected, format: .dateTime.year().month().day())
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        //.padding(.horizontal)
                        
                        Spacer()
                        Toggle(isOn: $dateToogleIsOn.animation()) { }
                            .fixedSize()
                            .onChange(of: dateToogleIsOn) { newValue in
                                if !newValue { timeToogleIsOn = false }
                            }
                    }
                    .animation(nil)
                    
                    if dateToogleIsOn {
                        DatePicker("Select Date", selection: $dateSelected, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            
                    }
                    
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .foregroundColor(.blue)
                                .frame(width: 30, height: 30)
                            Image(systemName: "clock.fill")
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Time")
                            if timeToogleIsOn {
                                Text(timeSelected, format: .dateTime.hour().minute())
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        Spacer()
                        Toggle(isOn: $timeToogleIsOn.animation()) {  }
                            .fixedSize()
                            .onChange(of: timeToogleIsOn) { newValue in
                                if newValue { dateToogleIsOn = true }
                            }
                    }
                    .animation(nil)
                    
                    if timeToogleIsOn {
                        DatePicker("Select Time", selection: $timeSelected, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                    }
                }
                
                Section {
                    HStack {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .foregroundColor(.orange)
                                .frame(width: 30, height: 30)
                            Image(systemName: "flag.fill")
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Flag")
                        }
                        Spacer()
                        Toggle(isOn: $flagToogleIsOn) { }
                            .fixedSize()
                        
                        
                    }
                }
                
                Section {
                    HStack {
                        Picker("Priority", selection: $priority) {
                            ForEach(priorities, id: \.self) { priority in
                                Text(priority)
                                if priority == priorities.first ?? "None" {
                                    Divider()
                                }
                            }
                        }
                    }
                }
            }
            
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { addTask() }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            
        }
    }
    
    func addTask() {
        viewModel.edit(newTitle: title, newNotes: notes,  newDate: dateToogleIsOn ? dateSelected : nil, newTime: timeToogleIsOn ? timeSelected : nil, newFlag: flagToogleIsOn, newPriority: priority)
        NotificationsProvider.shared.createNotificationContent(from: viewModel.task, date: dateToogleIsOn, time: timeToogleIsOn)
        dismiss()
    }
    
    func askForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct EditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        EditTaskView(viewModel: TaskViewModel(for: TaskItem(title: "Buy Gift", listID: UUID(), notes: "For mum", hasFlag: true, priority: .high, date: Date.now, time: Date.now)))
    }
}
