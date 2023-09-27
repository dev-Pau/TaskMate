//
//  Date+Extensionso.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 7/5/23.
//

import Foundation

extension Date {
    
    /// Check if date is today.
    ///
    /// - Returns:
    ///   - True if date is today.
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }

    /// Hour component for a given date.
    ///
    /// - Returns:
    ///   - Hour.
    var hour: Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: self)
    }
    
    /// Minutes component for a given date.
    ///
    /// - Returns:
    ///   - Minutes.
    var minute: Int {
        let calendar = Calendar.current
        return calendar.component(.minute, from: self)
    }
    
    /// Year component for a given date.
    ///
    /// - Returns:
    ///   - Year.
    var year: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    
    /// Month component for a given date.
    ///
    /// - Returns:
    ///   - Month.
    var month: Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    
    /// Day component for a given date.
    ///
    /// - Returns:
    ///   - Day.
    var day: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
    
    
    var dateComponents: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
    }
}
