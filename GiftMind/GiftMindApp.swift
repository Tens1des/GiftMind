//
//  GiftMindApp.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import SwiftUI

@main
struct GiftMindApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
