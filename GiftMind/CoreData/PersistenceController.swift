//
//  PersistenceController.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import CoreData
import Foundation

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        // Create the managed object model programmatically
        let model = NSManagedObjectModel()
        
        // Person entity
        let personEntity = NSEntityDescription()
        personEntity.name = "Person"
        personEntity.managedObjectClassName = "Person"
        
        let personId = NSAttributeDescription()
        personId.name = "id"
        personId.attributeType = .UUIDAttributeType
        personId.isOptional = false
        
        let personName = NSAttributeDescription()
        personName.name = "name"
        personName.attributeType = .stringAttributeType
        personName.isOptional = false
        
        let personBirthDay = NSAttributeDescription()
        personBirthDay.name = "birthDay"
        personBirthDay.attributeType = .integer16AttributeType
        personBirthDay.isOptional = false
        personBirthDay.defaultValue = 1
        
        let personBirthMonth = NSAttributeDescription()
        personBirthMonth.name = "birthMonth"
        personBirthMonth.attributeType = .integer16AttributeType
        personBirthMonth.isOptional = false
        personBirthMonth.defaultValue = 1
        
        let personInterests = NSAttributeDescription()
        personInterests.name = "interests"
        personInterests.attributeType = .stringAttributeType
        personInterests.isOptional = true
        
        let personGiftIdeas = NSAttributeDescription()
        personGiftIdeas.name = "giftIdeas"
        personGiftIdeas.attributeType = .stringAttributeType
        personGiftIdeas.isOptional = true
        
        let personCreatedAt = NSAttributeDescription()
        personCreatedAt.name = "createdAt"
        personCreatedAt.attributeType = .dateAttributeType
        personCreatedAt.isOptional = false
        
        let personUpdatedAt = NSAttributeDescription()
        personUpdatedAt.name = "updatedAt"
        personUpdatedAt.attributeType = .dateAttributeType
        personUpdatedAt.isOptional = false
        
        personEntity.properties = [personId, personName, personBirthDay, personBirthMonth, personInterests, personGiftIdeas, personCreatedAt, personUpdatedAt]
        
        // UserSettings entity
        let userSettingsEntity = NSEntityDescription()
        userSettingsEntity.name = "UserSettings"
        userSettingsEntity.managedObjectClassName = "UserSettings"
        
        let settingsId = NSAttributeDescription()
        settingsId.name = "id"
        settingsId.attributeType = .UUIDAttributeType
        settingsId.isOptional = false
        
        let settingsUsername = NSAttributeDescription()
        settingsUsername.name = "username"
        settingsUsername.attributeType = .stringAttributeType
        settingsUsername.isOptional = false
        settingsUsername.defaultValue = "User"
        
        let settingsAvatar = NSAttributeDescription()
        settingsAvatar.name = "avatar"
        settingsAvatar.attributeType = .stringAttributeType
        settingsAvatar.isOptional = false
        settingsAvatar.defaultValue = "person.circle"
        
        let settingsLanguage = NSAttributeDescription()
        settingsLanguage.name = "language"
        settingsLanguage.attributeType = .stringAttributeType
        settingsLanguage.isOptional = false
        settingsLanguage.defaultValue = "en"
        
        let settingsIsDarkMode = NSAttributeDescription()
        settingsIsDarkMode.name = "isDarkMode"
        settingsIsDarkMode.attributeType = .booleanAttributeType
        settingsIsDarkMode.isOptional = false
        settingsIsDarkMode.defaultValue = false
        
        let settingsColorScheme = NSAttributeDescription()
        settingsColorScheme.name = "colorScheme"
        settingsColorScheme.attributeType = .stringAttributeType
        settingsColorScheme.isOptional = false
        settingsColorScheme.defaultValue = "purple"
        
        let settingsCreatedAt = NSAttributeDescription()
        settingsCreatedAt.name = "createdAt"
        settingsCreatedAt.attributeType = .dateAttributeType
        settingsCreatedAt.isOptional = false
        
        let settingsUpdatedAt = NSAttributeDescription()
        settingsUpdatedAt.name = "updatedAt"
        settingsUpdatedAt.attributeType = .dateAttributeType
        settingsUpdatedAt.isOptional = false
        
        userSettingsEntity.properties = [settingsId, settingsUsername, settingsAvatar, settingsLanguage, settingsIsDarkMode, settingsColorScheme, settingsCreatedAt, settingsUpdatedAt]
        
        // Achievement entity
        let achievementEntity = NSEntityDescription()
        achievementEntity.name = "Achievement"
        achievementEntity.managedObjectClassName = "Achievement"
        
        let achievementId = NSAttributeDescription()
        achievementId.name = "id"
        achievementId.attributeType = .UUIDAttributeType
        achievementId.isOptional = false
        
        let achievementTitle = NSAttributeDescription()
        achievementTitle.name = "title"
        achievementTitle.attributeType = .stringAttributeType
        achievementTitle.isOptional = false
        
        let achievementDescription = NSAttributeDescription()
        achievementDescription.name = "achievementDescription"
        achievementDescription.attributeType = .stringAttributeType
        achievementDescription.isOptional = false
        
        let achievementIsCompleted = NSAttributeDescription()
        achievementIsCompleted.name = "isCompleted"
        achievementIsCompleted.attributeType = .booleanAttributeType
        achievementIsCompleted.isOptional = false
        achievementIsCompleted.defaultValue = false
        
        let achievementCompletedDate = NSAttributeDescription()
        achievementCompletedDate.name = "completedDate"
        achievementCompletedDate.attributeType = .dateAttributeType
        achievementCompletedDate.isOptional = true
        
        let achievementXpReward = NSAttributeDescription()
        achievementXpReward.name = "xpReward"
        achievementXpReward.attributeType = .integer16AttributeType
        achievementXpReward.isOptional = false
        achievementXpReward.defaultValue = 0
        
        let achievementCategory = NSAttributeDescription()
        achievementCategory.name = "category"
        achievementCategory.attributeType = .stringAttributeType
        achievementCategory.isOptional = true
        
        let achievementCreatedAt = NSAttributeDescription()
        achievementCreatedAt.name = "createdAt"
        achievementCreatedAt.attributeType = .dateAttributeType
        achievementCreatedAt.isOptional = false
        
        achievementEntity.properties = [achievementId, achievementTitle, achievementDescription, achievementIsCompleted, achievementCompletedDate, achievementXpReward, achievementCategory, achievementCreatedAt]
        
        // Gift entity
        let giftEntity = NSEntityDescription()
        giftEntity.name = "Gift"
        giftEntity.managedObjectClassName = "Gift"
        
        let giftId = NSAttributeDescription()
        giftId.name = "id"
        giftId.attributeType = .UUIDAttributeType
        giftId.isOptional = false
        
        let giftTitle = NSAttributeDescription()
        giftTitle.name = "title"
        giftTitle.attributeType = .stringAttributeType
        giftTitle.isOptional = false
        
        let giftDescription = NSAttributeDescription()
        giftDescription.name = "giftDescription"
        giftDescription.attributeType = .stringAttributeType
        giftDescription.isOptional = true
        
        let giftIsGifted = NSAttributeDescription()
        giftIsGifted.name = "isGifted"
        giftIsGifted.attributeType = .booleanAttributeType
        giftIsGifted.isOptional = false
        giftIsGifted.defaultValue = false
        
        let giftGiftedDate = NSAttributeDescription()
        giftGiftedDate.name = "giftedDate"
        giftGiftedDate.attributeType = .dateAttributeType
        giftGiftedDate.isOptional = true
        
        let giftCreatedAt = NSAttributeDescription()
        giftCreatedAt.name = "createdAt"
        giftCreatedAt.attributeType = .dateAttributeType
        giftCreatedAt.isOptional = false
        
        giftEntity.properties = [giftId, giftTitle, giftDescription, giftIsGifted, giftGiftedDate, giftCreatedAt]
        
        // WishlistItem entity
        let wishlistItemEntity = NSEntityDescription()
        wishlistItemEntity.name = "WishlistItem"
        wishlistItemEntity.managedObjectClassName = "WishlistItem"
        
        let wishlistId = NSAttributeDescription()
        wishlistId.name = "id"
        wishlistId.attributeType = .UUIDAttributeType
        wishlistId.isOptional = false
        
        let wishlistTitle = NSAttributeDescription()
        wishlistTitle.name = "title"
        wishlistTitle.attributeType = .stringAttributeType
        wishlistTitle.isOptional = false
        
        let wishlistUrl = NSAttributeDescription()
        wishlistUrl.name = "url"
        wishlistUrl.attributeType = .stringAttributeType
        wishlistUrl.isOptional = true
        
        let wishlistPrice = NSAttributeDescription()
        wishlistPrice.name = "price"
        wishlistPrice.attributeType = .stringAttributeType
        wishlistPrice.isOptional = true
        
        let wishlistStore = NSAttributeDescription()
        wishlistStore.name = "store"
        wishlistStore.attributeType = .stringAttributeType
        wishlistStore.isOptional = true
        
        let wishlistCategory = NSAttributeDescription()
        wishlistCategory.name = "category"
        wishlistCategory.attributeType = .stringAttributeType
        wishlistCategory.isOptional = true
        
        let wishlistPriority = NSAttributeDescription()
        wishlistPriority.name = "priority"
        wishlistPriority.attributeType = .stringAttributeType
        wishlistPriority.isOptional = true
        wishlistPriority.defaultValue = "medium"
        
        let wishlistCreatedAt = NSAttributeDescription()
        wishlistCreatedAt.name = "createdAt"
        wishlistCreatedAt.attributeType = .dateAttributeType
        wishlistCreatedAt.isOptional = false
        
        wishlistItemEntity.properties = [wishlistId, wishlistTitle, wishlistUrl, wishlistPrice, wishlistStore, wishlistCategory, wishlistPriority, wishlistCreatedAt]
        
        // Set up relationships
        let personGiftsRelationship = NSRelationshipDescription()
        personGiftsRelationship.name = "gifts"
        personGiftsRelationship.destinationEntity = giftEntity
        personGiftsRelationship.maxCount = 0
        personGiftsRelationship.deleteRule = .cascadeDeleteRule
        
        let giftPersonRelationship = NSRelationshipDescription()
        giftPersonRelationship.name = "person"
        giftPersonRelationship.destinationEntity = personEntity
        giftPersonRelationship.maxCount = 1
        giftPersonRelationship.deleteRule = .nullifyDeleteRule
        
        personGiftsRelationship.inverseRelationship = giftPersonRelationship
        giftPersonRelationship.inverseRelationship = personGiftsRelationship
        
        let personWishlistRelationship = NSRelationshipDescription()
        personWishlistRelationship.name = "wishlist"
        personWishlistRelationship.destinationEntity = wishlistItemEntity
        personWishlistRelationship.maxCount = 0
        personWishlistRelationship.deleteRule = .cascadeDeleteRule
        
        let wishlistPersonRelationship = NSRelationshipDescription()
        wishlistPersonRelationship.name = "person"
        wishlistPersonRelationship.destinationEntity = personEntity
        wishlistPersonRelationship.maxCount = 1
        wishlistPersonRelationship.deleteRule = .nullifyDeleteRule
        
        personWishlistRelationship.inverseRelationship = wishlistPersonRelationship
        wishlistPersonRelationship.inverseRelationship = personWishlistRelationship
        
        // Add relationships to entities
        personEntity.properties.append(personGiftsRelationship)
        personEntity.properties.append(personWishlistRelationship)
        giftEntity.properties.append(giftPersonRelationship)
        wishlistItemEntity.properties.append(wishlistPersonRelationship)
        
        // Add entities to model
        model.entities = [personEntity, userSettingsEntity, achievementEntity, giftEntity, wishlistItemEntity]
        
        container = NSPersistentContainer(name: "GiftMind", managedObjectModel: model)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Core Data error: \(error), \(error.userInfo)")
            } else {
                print("Core Data loaded successfully")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
}
