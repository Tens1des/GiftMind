//
//  Gift.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import Foundation
import CoreData

@objc(Gift)
public class Gift: NSManagedObject {
    
}

extension Gift {
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var giftDescription: String?
    @NSManaged public var isGifted: Bool
    @NSManaged public var giftedDate: Date?
    @NSManaged public var createdAt: Date
    @NSManaged public var person: Person?
}

extension Gift : Identifiable {
    
}
