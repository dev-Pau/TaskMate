//
//  ListPriority.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 8/5/23.
//

import Foundation

/// An enum mapping all of the possible priorities for a TaskItem.
enum ListPriority: String, CaseIterable {
    
    case whenever, low, medium, high
    
    var title: String {
        switch self {
        case .whenever: return String()
        case .low: return "!"
        case .medium: return "!!"
        case .high: return "!!!"
        }
    }
}
