//
//  UserSettings.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import Foundation
import CoreData

@objc(UserSettings)
public class UserSettings: NSManagedObject {
    
}

extension UserSettings {
    
    @NSManaged public var id: UUID
    @NSManaged public var username: String
    @NSManaged public var avatar: String
    @NSManaged public var language: String
    @NSManaged public var isDarkMode: Bool
    @NSManaged public var colorScheme: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
}

extension UserSettings : Identifiable {
    
}
