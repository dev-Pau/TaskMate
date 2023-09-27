//
//  ListViewModelTests.swift
//  TaskMateTests
//
//  Created by Pau Fernández Solà on 27/9/23.
//

import XCTest
@testable import Task_Mate

final class ListViewModelTests: XCTestCase {
    
    var sut: ListViewModel!
    
    override func setUpWithError() throws {
        sut = ListViewModel(for: ListItem(title: "Test List", color: .blue, image: "test_image"))
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testListViewModelWhenCompeletedTasksAreLoaded() {
        sut.loadCompletedTasks()
        
        XCTAssertEqual(sut.completedTasks.count, 0)
    }
    
    func testListViewModelWhenTaskIsCleared() {
        let taskItem = TaskItem(title: "Test Task", listID: sut.list.id, notes: "Test Notes", hasFlag: false, priority: .low)
        
        sut.add(task: taskItem)
        
        XCTAssertEqual(sut.tasks.count, 1)
        
        sut.clear(task: taskItem)
        
        XCTAssertEqual(sut.tasks.count, 0)
    }
    
    func testListViewModelWhenTasksAreSorted() {
        // Create two TaskItems with different dates
        let date1 = Date(timeIntervalSinceNow: 1000) // A future date
        let date2 = Date(timeIntervalSinceNow: 500)  // Another future date
        
        let taskItem1 = TaskItem(title: "Task 1", listID: UUID(), notes: "Notes 1", hasFlag: false, priority: .low, date: date1, time: nil)
        let taskItem2 = TaskItem(title: "Task 2", listID: UUID(), notes: "Notes 2", hasFlag: false, priority: .medium, date: date2, time: nil)
        
        sut.add(task: taskItem1)
        sut.add(task: taskItem2)
        
        XCTAssertEqual(sut.tasks.count, 2)
        XCTAssertEqual(sut.tasks[0].task.title, "Task 2")
        XCTAssertEqual(sut.tasks[1].task.title, "Task 1")
    }
}
