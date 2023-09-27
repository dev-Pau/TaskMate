//
//  ListPriorityTests.swift
//  TaskMateTests
//
//  Created by Pau Fernández Solà on 27/9/23.
//

import XCTest
@testable import Task_Mate

final class ListPriorityTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testListPriorityWhenIsWhenever() {
        let priority = ListPriority.whenever
        XCTAssertEqual(priority.title, "")
    }
    
    func testListPriorityWhenIsLow() {
        let priority = ListPriority.low
        XCTAssertEqual(priority.title, "!")
    }
    
    func testListPriorityWhenTitleIsMedium() {
        let priority = ListPriority.medium
        XCTAssertEqual(priority.title, "!!")
    }
    
    func testListPriorityWhenTitleIsHigh() {
        let priority = ListPriority.high
        XCTAssertEqual(priority.title, "!!!")
    }
}
