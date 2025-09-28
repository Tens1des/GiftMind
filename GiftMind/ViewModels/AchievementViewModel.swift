//
//  AchievementViewModel.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import Foundation
import CoreData
import SwiftUI

class AchievementViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let persistenceController = PersistenceController.shared
    private var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    init() {
        setupNotifications()
        initializeAchievements()
        fetchAchievements()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            forName: .personAdded,
            object: nil,
            queue: .main
        ) { _ in
            self.checkAchievements()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initializeAchievements() {
        let request: NSFetchRequest<Achievement> = NSFetchRequest<Achievement>(entityName: "Achievement")
        
        do {
            let existingAchievements = try viewContext.fetch(request)
            if existingAchievements.isEmpty {
                createDefaultAchievements()
            }
        } catch {
            print("Error checking achievements: \(error)")
        }
    }
    
    private func createDefaultAchievements() {
        let defaultAchievements = [
            ("First Step", "Add the first person to the calendar", 50, "common"),
            ("Date Keeper", "Fill birthdays for a whole month", 100, "uncommon"),
            ("Year Planner", "Add dates for all 12 months", 200, "rare"),
            ("Thinker", "Add first note about person's interests", 50, "common"),
            ("Idea in Pocket", "Record first gift idea", 50, "common"),
            ("Idea Generator", "Save 10 gift ideas", 150, "uncommon"),
            ("Small List", "Add 5 people to the app", 100, "uncommon"),
            ("Big Company", "Add 20 people to the app", 300, "rare"),
            ("Attentive", "Check calendar a week before event", 75, "common"),
            ("Caring", "Update interests for 5 different people", 150, "uncommon"),
            ("Party Master", "Mark 10 gifts as given", 200, "rare"),
            ("Consistency", "Use the app for 30 days in a row", 500, "legendary")
        ]
        
        for (title, description, xp, category) in defaultAchievements {
            let achievement = Achievement(context: viewContext)
            achievement.id = UUID()
            achievement.title = title
            achievement.achievementDescription = description
            achievement.xpReward = Int16(xp)
            achievement.category = category
            achievement.isCompleted = false
            achievement.createdAt = Date()
        }
        
        saveContext()
    }
    
    func fetchAchievements() {
        isLoading = true
        
        let request: NSFetchRequest<Achievement> = NSFetchRequest<Achievement>(entityName: "Achievement")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Achievement.isCompleted, ascending: true),
                                  NSSortDescriptor(keyPath: \Achievement.xpReward, ascending: false)]
        
        do {
            achievements = try viewContext.fetch(request)
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch achievements: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func checkAchievements() {
        // Check various achievement conditions
        checkFirstPersonAchievement()
        checkDateKeeperAchievement()
        checkYearPlannerAchievement()
        checkThinkerAchievement()
        checkIdeaInPocketAchievement()
        checkIdeaGeneratorAchievement()
        checkSmallListAchievement()
        checkBigCompanyAchievement()
        checkPartyMasterAchievement()
        
        saveContext()
        fetchAchievements()
    }
    
    private func checkFirstPersonAchievement() {
        let personRequest: NSFetchRequest<Person> = NSFetchRequest<Person>(entityName: "Person")
        do {
            let personCount = try viewContext.count(for: personRequest)
            if personCount >= 1 {
                completeAchievement(title: "First Step")
            }
        } catch {
            print("Error checking first person achievement: \(error)")
        }
    }
    
    private func checkDateKeeperAchievement() {
        let personRequest: NSFetchRequest<Person> = NSFetchRequest<Person>(entityName: "Person")
        do {
            let persons = try viewContext.fetch(personRequest)
            let monthCounts = Dictionary(grouping: persons) { $0.birthMonth }
            if monthCounts.count >= 1 {
                completeAchievement(title: "Date Keeper")
            }
        } catch {
            print("Error checking date keeper achievement: \(error)")
        }
    }
    
    private func checkYearPlannerAchievement() {
        let personRequest: NSFetchRequest<Person> = NSFetchRequest<Person>(entityName: "Person")
        do {
            let persons = try viewContext.fetch(personRequest)
            let monthCounts = Dictionary(grouping: persons) { $0.birthMonth }
            if monthCounts.count >= 12 {
                completeAchievement(title: "Year Planner")
            }
        } catch {
            print("Error checking year planner achievement: \(error)")
        }
    }
    
    private func checkThinkerAchievement() {
        let personRequest: NSFetchRequest<Person> = NSFetchRequest<Person>(entityName: "Person")
        personRequest.predicate = NSPredicate(format: "interests != nil AND interests != ''")
        do {
            let personCount = try viewContext.count(for: personRequest)
            if personCount >= 1 {
                completeAchievement(title: "Thinker")
            }
        } catch {
            print("Error checking thinker achievement: \(error)")
        }
    }
    
    private func checkIdeaInPocketAchievement() {
        let personRequest: NSFetchRequest<Person> = NSFetchRequest<Person>(entityName: "Person")
        personRequest.predicate = NSPredicate(format: "giftIdeas != nil AND giftIdeas != ''")
        do {
            let personCount = try viewContext.count(for: personRequest)
            if personCount >= 1 {
                completeAchievement(title: "Idea in Pocket")
            }
        } catch {
            print("Error checking idea in pocket achievement: \(error)")
        }
    }
    
    private func checkIdeaGeneratorAchievement() {
        let wishlistRequest: NSFetchRequest<WishlistItem> = NSFetchRequest<WishlistItem>(entityName: "WishlistItem")
        do {
            let wishlistCount = try viewContext.count(for: wishlistRequest)
            if wishlistCount >= 10 {
                completeAchievement(title: "Idea Generator")
            }
        } catch {
            print("Error checking idea generator achievement: \(error)")
        }
    }
    
    private func checkSmallListAchievement() {
        let personRequest: NSFetchRequest<Person> = NSFetchRequest<Person>(entityName: "Person")
        do {
            let personCount = try viewContext.count(for: personRequest)
            if personCount >= 5 {
                completeAchievement(title: "Small List")
            }
            if personCount >= 20 {
                completeAchievement(title: "Big Company")
            }
        } catch {
            print("Error checking list achievements: \(error)")
        }
    }
    
    private func checkBigCompanyAchievement() {
        let personRequest: NSFetchRequest<Person> = NSFetchRequest<Person>(entityName: "Person")
        do {
            let personCount = try viewContext.count(for: personRequest)
            if personCount >= 20 {
                completeAchievement(title: "Big Company")
            }
        } catch {
            print("Error checking big company achievement: \(error)")
        }
    }
    
    private func checkPartyMasterAchievement() {
        let giftRequest: NSFetchRequest<Gift> = NSFetchRequest<Gift>(entityName: "Gift")
        giftRequest.predicate = NSPredicate(format: "isGifted == YES")
        do {
            let giftedCount = try viewContext.count(for: giftRequest)
            if giftedCount >= 10 {
                completeAchievement(title: "Party Master")
            }
        } catch {
            print("Error checking party master achievement: \(error)")
        }
    }
    
    private func completeAchievement(title: String) {
        let request: NSFetchRequest<Achievement> = NSFetchRequest<Achievement>(entityName: "Achievement")
        request.predicate = NSPredicate(format: "title == %@ AND isCompleted == NO", title)
        
        do {
            let achievements = try viewContext.fetch(request)
            if let achievement = achievements.first {
                achievement.isCompleted = true
                achievement.completedDate = Date()
            }
        } catch {
            print("Error completing achievement: \(error)")
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}
