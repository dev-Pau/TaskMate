//
//  AppPublishers.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import UIKit

/// A structure containing publishers used throughout the app.
struct AppPublishers {
    
    struct Names {
        static let refreshLists = "RefreshLists"
        static let refreshTasks = "RefreshTasks"
    }
    
    static let refreshToDoListPublisher = NotificationCenter.default.publisher(for: NSNotification.Name(Names.refreshLists))
    static let refreshToDoTasksPublisher = NotificationCenter.default.publisher(for: NSNotification.Name(Names.refreshTasks))
}
