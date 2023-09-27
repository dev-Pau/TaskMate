//
//  TaskItem.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import CoreData
import Foundation
import UIKit

struct ListItem: Identifiable {
    
    let id: UUID
    private(set) var title: String
    let color: UIColor
    let image: String
    
    /// Creates an instance of a ListItem.
    ///
    /// - Parameters:
    ///   - title: The raw, user-inputted title of the List.
    ///   - color: The color of the List.
    ///   - image: The raw, image of the List.
    init(title: String, color: UIColor, image: String) {
        self.id = UUID()
        self.title = title
        self.color = color
        self.image = image
    }
    
    /// Creates an instance of a ListItem from a Core Data entity.
    ///
    /// - Parameters:
    ///   - entity: The ListEntity instance from the Core Data store.
    init?(fromEntity entity: ListEntity) {
        guard let entityIdentifier = entity.id else { return nil }
        
        self.id = entityIdentifier
        self.title = entity.wrappedTitle
        self.color = entity.wrappedColor
        self.image = entity.wrappedImage
    }
    
    /// Creates a ListEntity from the instance to be used with Core Data.
    ///
    /// - Returns:
    /// An instance of ListEntity.
    @discardableResult
    func getEntity(context: NSManagedObjectContext) -> ListEntity {
        let entity = ListEntity(context: context)
        
        entity.id = id
        entity.title = title
        entity.color = color
        entity.image = image
      
        return entity
    }
    
    /// Updates the instance's title property.
    ///
    /// - Parameters:
    ///   - newTitle: The new title to be updated.
    mutating func changeTitle(to newTitle: String) {
        title = newTitle
    }
}
