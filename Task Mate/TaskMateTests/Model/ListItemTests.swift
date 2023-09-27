//
//  ListItemTests.swift
//  TaskMateTests
//
//  Created by Pau Fernández Solà on 27/9/23.
//

import XCTest
@testable import Task_Mate

final class ListItemTests: XCTestCase {
    
    var sut: ListItem!
    
    override func setUpWithError() throws {
        sut = ListItem(title: "Test List", color: UIColor.red, image: "testImage")
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testListItemWhenItemIsInitialized() {
        
        XCTAssertEqual(sut.title, "Test List")
        XCTAssertEqual(sut.color, UIColor.red)
        XCTAssertEqual(sut.image, "testImage")
    }
    
    func testListItemWhenTitleIsChanged() {
        sut.changeTitle(to: "Updated List")
        
        XCTAssertEqual(sut.title, "Updated List")
    }
    
}
