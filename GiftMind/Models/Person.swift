//
//  Person.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject {
    
}

extension Person {
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var birthDay: Int16
    @NSManaged public var birthMonth: Int16
    @NSManaged public var interests: String?
    @NSManaged public var giftIdeas: String?
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var wishlist: NSSet?
    @NSManaged public var gifts: NSSet?
}

// MARK: Generated accessors for wishlist
extension Person {
    
    @objc(addWishlistObject:)
    @NSManaged public func addToWishlist(_ value: WishlistItem)
    
    @objc(removeWishlistObject:)
    @NSManaged public func removeFromWishlist(_ value: WishlistItem)
    
    @objc(addWishlist:)
    @NSManaged public func addToWishlist(_ values: NSSet)
    
    @objc(removeWishlist:)
    @NSManaged public func removeFromWishlist(_ values: NSSet)
}

// MARK: Generated accessors for gifts
extension Person {
    
    @objc(addGiftsObject:)
    @NSManaged public func addToGifts(_ value: Gift)
    
    @objc(removeGiftsObject:)
    @NSManaged public func removeFromGifts(_ value: Gift)
    
    @objc(addGifts:)
    @NSManaged public func addToGifts(_ values: NSSet)
    
    @objc(removeGifts:)
    @NSManaged public func removeFromGifts(_ values: NSSet)
}

extension Person : Identifiable {
    
}
