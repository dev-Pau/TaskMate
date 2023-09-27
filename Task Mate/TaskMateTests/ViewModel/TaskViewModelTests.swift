//
//  TaskViewModelTests.swift
//  TaskMateTests
//
//  Created by Pau Fernández Solà on 27/9/23.
//

import XCTest
@testable import Task_Mate
import CoreData

final class TaskViewModelTests: XCTestCase {
    
    var sut: TaskViewModel!
    
    override func setUpWithError() throws {
        sut = TaskViewModel(for: TaskItem(title: "Test Task", listID: UUID(), notes: "Test Notes", hasFlag: false, priority: .low))
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testTaskViewModelWhenTaskIsEdited() {
        sut.edit(newTitle: "Updated Task", newNotes: "Updated Notes", newFlag: true, newPriority: "medium")
        
        XCTAssertEqual(sut.task.title, "Updated Task")
        XCTAssertEqual(sut.task.notes, "Updated Notes")
        XCTAssertTrue(sut.task.hasFlag)
        XCTAssertEqual(sut.task.priority, .medium)
    }
    
    func testTaskViewModelWhenTaskIsCompleted() {
        sut.markAsComplete()
        sut.markAsIncomplete()
        XCTAssertFalse(sut.task.isCompleted)
        XCTAssertNil(sut.task.completionDate)
    }
    
    func testTaskViewModelWhenFlagIsToggled() {
        sut.toggleFlag()
        XCTAssertTrue(sut.task.hasFlag)
    }
}
