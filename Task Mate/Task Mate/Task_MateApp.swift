//
//  Task_MateApp.swift
//  Task Mate
//
//  Created by Pau Fernández Solà on 6/5/23.
//

import SwiftUI

@main
struct Task_MateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, DataProvider.shared.persistentContainer.viewContext)
        }
    }
}
