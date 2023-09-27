//
//  TaskItemTests.swift
//  TaskMateTests
//
//  Created by Pau Fernández Solà on 27/9/23.
//

import XCTest
@testable import Task_Mate

final class TaskItemTests: XCTestCase {
    
    private var listID: UUID!
    private var sut: TaskItem!

    override func setUpWithError() throws {
        listID = UUID()
        sut = TaskItem(title: "Test Task", listID: listID, notes: "Test Notes", hasFlag: true, priority: .medium)
    }

    override func tearDownWithError() throws {
        sut = nil
        listID = nil
    }

    func testTaskItemWhenItemIsInitialized() {
        XCTAssertEqual(sut.title, "Test Task")
        XCTAssertEqual(sut.listID, listID)
        XCTAssertEqual(sut.notes, "Test Notes")
        XCTAssertFalse(sut.isCompleted)
        XCTAssertNil(sut.completionDate)
        XCTAssertEqual(sut.priority, .medium)
        XCTAssertTrue(sut.hasFlag)
        XCTAssertNil(sut.date)
        XCTAssertNil(sut.time)
    }
    
    func testTaskItemWhenItemIsEdited() {
        sut.edit(newTitle: "Updated Task", newNotes: "Updated Notes", newFlag: false, newPriority: "low")
        
        XCTAssertEqual(sut.title, "Updated Task")
        XCTAssertEqual(sut.notes, "Updated Notes")
        XCTAssertFalse(sut.hasFlag)
        XCTAssertEqual(sut.priority, .low)
    }
    
    func testTaskItemWhenToggleCompletionState() {
        sut.toogleCompletionState()
        
        XCTAssertTrue(sut.isCompleted)
        
        sut.toogleCompletionState()
        
        XCTAssertFalse(sut.isCompleted)
    }
    
    func testTaskItemWhenSetCompletionDate() {
        sut.setCompletionDate()
        XCTAssertNotNil(sut.completionDate)
    }
}
