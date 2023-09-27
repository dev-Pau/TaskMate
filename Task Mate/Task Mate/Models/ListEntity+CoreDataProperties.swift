//
//  ListEntity+CoreDataProperties.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 6/5/23.
//
//

import Foundation
import CoreData
import UIKit


extension ListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListEntity> {
        return NSFetchRequest<ListEntity>(entityName: "ListEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var color: UIColor?
    @NSManaged public var image: String?
    @NSManaged public var tasks: NSSet?
    
    public var wrappedTitle: String {
        title ?? "Unknown List"
    }
    
    public var wrappedImage: String {
        image ?? "checkmark"
    }
    
    public var wrappedColor: UIColor {
        color ?? .systemPink
    }

}

extension ListEntity : Identifiable {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskEntity)
    
    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskEntity)
    
    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)
    
    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)
}
