//
//  TaskEntity+CoreDataProperties.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var hasFlag: Bool
    @NSManaged public var notes: String?
    @NSManaged public var time: Date?
    @NSManaged public var completedDate: Date?
    @NSManaged public var priority: String?
    @NSManaged public var title: String?
    @NSManaged public var list: ListEntity?
    
    public var wrappedTitle: String {
        title ?? "Unknown Title"
    }
    
    public var wrappedNotes: String {
        notes ?? String()
    }
    
    public var wrappedPriority: String {
        priority ?? "None"
    }
}

extension TaskEntity : Identifiable {

}
