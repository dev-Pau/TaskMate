//
//  NotificationsProvider.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 10/5/23.
//

import Foundation
import UserNotifications

/// The service provider used to interface with EventKit.
struct NotificationsProvider {
    
    static let shared = NotificationsProvider()
    
    func createNotificationContent(from task: TaskItem, date: Bool, time: Bool) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = task.title
            content.subtitle = task.notes
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            if date {
                dateComponents.year = task.date?.year
                dateComponents.month = task.date?.month
                dateComponents.day = task.date?.day
                
                dateComponents.hour = time ? task.time?.hour : 9
                dateComponents.minute = time ? task.time?.minute : 0
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        
                    }
                }
            }
        }
    }
}
