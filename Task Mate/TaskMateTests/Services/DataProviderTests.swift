//
//  DataProviderTests.swift
//  TaskMateTests
//
//  Created by Pau Fernández Solà on 27/9/23.
//

import XCTest
import CoreData
@testable import Task_Mate

final class DataProviderTests: XCTestCase {
    
    var dataProvider: DataProvider!
  
    override func setUpWithError() throws {
        dataProvider = DataProvider(for: mockPersistantContainer)
    }

    override func tearDownWithError() throws {
        dataProvider = nil
    }

    func testDataProviderWhenListIsSaved() {
        let listToSave = ListItem(title: "Test List", color: .green, image: "image1")
        dataProvider.save(list: listToSave)
        let savedLists = dataProvider.getLists()
        
        XCTAssertEqual(savedLists.count, 1)
    }
    
    func testDataProviderWhenTaskIsSaved(){
        
        let listToSave = ListItem(title: "Associated List", color: .blue, image: "image2")
        
        let taskToSave = TaskItem(title: "Test Task", listID: listToSave.id, notes: "Notes", hasFlag: false, priority: .low)
        
        dataProvider.save(list: listToSave)
        dataProvider.save(task: taskToSave, for: listToSave)
        
        let savedTasks = dataProvider.getTasks(for: listToSave)
        XCTAssertEqual(savedTasks.count, 1)
        XCTAssertEqual(savedTasks.first?.title, "Test Task")
    }
    
    func testDataProviderWhenGetLists() {
        let list1 = ListItem(title: "List 1", color: .red, image: "image3")
        let list2 = ListItem(title: "List 2", color: .green, image: "image4")
        dataProvider.save(list: list1)
        dataProvider.save(list: list2)
        
        let retrievedLists = dataProvider.getLists()
        
        XCTAssertEqual(retrievedLists.count, 2)
        XCTAssertTrue(retrievedLists.contains(where: { $0.title == "List 1" }))
        XCTAssertTrue(retrievedLists.contains(where: { $0.title == "List 2" }))
    }
    
    func testDataProviderWhenListIsUpdated() {
        let listToUpdate = ListItem(title: "List to Update", color: .purple, image: "image5")
        dataProvider.save(list: listToUpdate)

        dataProvider.update(list: listToUpdate, set: "Updated Title", forKey: "title")
        
        let lists = dataProvider.getLists()
        
        XCTAssertEqual(lists.count, 1)
        XCTAssertEqual(lists.first?.title, "Updated Title")
    }
    
    func testDataProviderWhenListIsDeleted() {
        let listToDelete = ListItem(title: "List to Delete", color: .orange, image: "image6")
        dataProvider.save(list: listToDelete)
        
        dataProvider.delete(list: listToDelete)
        
        let lists = dataProvider.getLists()
        
        XCTAssertEqual(lists.count, 0)
    }
    
    func testDataProviderWhenTaskIsDeletedFromList() {
        let listToSave = ListItem(title: "Associated List", color: .blue, image: "image7")

        let taskToDelete = TaskItem(title: "Task to Delete", listID: listToSave.id, notes: "Notes", hasFlag: false, priority: .low)
        dataProvider.save(task: taskToDelete, for: listToSave)

        dataProvider.delete(task: taskToDelete, for: listToSave)
        
        let tasks = dataProvider.getTasks(for: listToSave)
        XCTAssertEqual(tasks.count, 0)
    }
    
    func testDataProviderWhenTaskIsUpdated() {
        let list = ListItem(title: "Associated List", color: .green, image: "image8")
        let taskToUpdate = TaskItem(title: "Task to Update", listID: list.id, notes: "Notes", hasFlag: true, priority: .high)
        dataProvider.save(list: list)
        dataProvider.save(task: taskToUpdate, for: list)

        dataProvider.edit(task: taskToUpdate, set: "Updated Notes", forKey: "notes")
     
        let task = dataProvider.getTasks(for: list)
        
        XCTAssertEqual(task.count, 1)
        XCTAssertEqual(task.first?.notes, "Updated Notes")
    }
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskMate")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()

}
