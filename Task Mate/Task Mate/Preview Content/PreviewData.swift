//
//  PreviewData.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import Foundation
import CoreData

class PreviewData {
    
    static var previewList: ListEntity {
        let viewContext = DataProvider.shared.persistentContainer.viewContext
        let request = ListEntity.fetchRequest()
        return (try? viewContext.fetch(request).first) ?? ListEntity()
    }
    
    static var previewTask: TaskEntity {
        let viewContext = DataProvider.shared.persistentContainer.viewContext
        let request = TaskEntity.fetchRequest()
        return (try? viewContext.fetch(request).first) ?? TaskEntity(context: viewContext)
    }
}
