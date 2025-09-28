//
//  Achievement.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import Foundation
import CoreData

@objc(Achievement)
public class Achievement: NSManagedObject {
    
}

extension Achievement {
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var achievementDescription: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var completedDate: Date?
    @NSManaged public var xpReward: Int16
    @NSManaged public var category: String
    @NSManaged public var createdAt: Date
}

extension Achievement : Identifiable {
    
}
