//
//  WishlistItem.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import Foundation
import CoreData

@objc(WishlistItem)
public class WishlistItem: NSManagedObject {
    
}

extension WishlistItem {
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var url: String?
    @NSManaged public var price: String?
    @NSManaged public var store: String?
    @NSManaged public var category: String?
    @NSManaged public var priority: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var person: Person?
}

extension WishlistItem : Identifiable {
    
}
