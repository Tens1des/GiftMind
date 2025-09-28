//
//  SettingsViewModel.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import Foundation
import CoreData
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var userSettings: UserSettings?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let persistenceController = PersistenceController.shared
    private var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    init() {
        fetchUserSettings()
    }
    
    func fetchUserSettings() {
        isLoading = true
        
        let request: NSFetchRequest<UserSettings> = NSFetchRequest<UserSettings>(entityName: "UserSettings")
        
        do {
            let settings = try viewContext.fetch(request)
            if let existingSettings = settings.first {
                userSettings = existingSettings
            } else {
                createDefaultSettings()
            }
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch user settings: \(error.localizedDescription)"
            print("Error fetching user settings: \(error)")
            isLoading = false
        }
    }
    
    private func createDefaultSettings() {
        let newSettings = UserSettings(context: viewContext)
        newSettings.id = UUID()
        newSettings.username = "User"
        newSettings.avatar = "person.circle"
        newSettings.language = "en"
        newSettings.isDarkMode = false
        newSettings.colorScheme = "purple"
        newSettings.createdAt = Date()
        newSettings.updatedAt = Date()
        
        userSettings = newSettings
        saveContext()
    }
    
    func updateUsername(_ username: String) {
        userSettings?.username = username
        userSettings?.updatedAt = Date()
        saveContext()
    }
    
    func updateAvatar(_ avatar: String) {
        userSettings?.avatar = avatar
        userSettings?.updatedAt = Date()
        saveContext()
    }
    
    func updateLanguage(_ language: String) {
        userSettings?.language = language
        userSettings?.updatedAt = Date()
        saveContext()
    }
    
    func updateTheme(isDarkMode: Bool) {
        userSettings?.isDarkMode = isDarkMode
        userSettings?.updatedAt = Date()
        saveContext()
        
        // Force UI update
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func updateColorScheme(_ colorScheme: String) {
        userSettings?.colorScheme = colorScheme
        userSettings?.updatedAt = Date()
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}
