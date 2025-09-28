//
//  PersonViewModel.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import Foundation
import CoreData
import SwiftUI

extension Notification.Name {
    static let personAdded = Notification.Name("personAdded")
}

class PersonViewModel: ObservableObject {
    @Published var persons: [Person] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let persistenceController = PersistenceController.shared
    private var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    init() {
        fetchPersons()
    }
    
    func fetchPersons() {
        isLoading = true
        
        let request: NSFetchRequest<Person> = NSFetchRequest<Person>(entityName: "Person")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Person.birthMonth, ascending: true),
                                  NSSortDescriptor(keyPath: \Person.birthDay, ascending: true)]
        
        do {
            persons = try viewContext.fetch(request)
            print("Fetched \(persons.count) persons from Core Data")
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch persons: \(error.localizedDescription)"
            print("Error fetching persons: \(error)")
            isLoading = false
        }
    }
    
    func addPerson(name: String, birthDay: Int, birthMonth: Int, interests: String?, giftIdeas: String?) {
        print("Adding person: \(name), day: \(birthDay), month: \(birthMonth)")
        
        let newPerson = Person(context: viewContext)
        newPerson.id = UUID()
        newPerson.name = name
        newPerson.birthDay = Int16(birthDay)
        newPerson.birthMonth = Int16(birthMonth)
        newPerson.interests = interests
        newPerson.giftIdeas = giftIdeas
        newPerson.createdAt = Date()
        newPerson.updatedAt = Date()
        
        saveContext()
        fetchPersons()
        
        print("After adding person, total persons: \(persons.count)")
        
        // Check achievements after adding a person
        NotificationCenter.default.post(name: .personAdded, object: nil)
    }
    
    func updatePerson(_ person: Person, name: String, birthDay: Int, birthMonth: Int, interests: String?, giftIdeas: String?) {
        person.name = name
        person.birthDay = Int16(birthDay)
        person.birthMonth = Int16(birthMonth)
        person.interests = interests
        person.giftIdeas = giftIdeas
        person.updatedAt = Date()
        
        saveContext()
        fetchPersons()
    }
    
    func deletePerson(_ person: Person) {
        viewContext.delete(person)
        saveContext()
        fetchPersons()
    }
    
    func getPersonsForDate(day: Int, month: Int) -> [Person] {
        let filtered = persons.filter { $0.birthDay == day && $0.birthMonth == month }
        print("getPersonsForDate(\(day), \(month)): found \(filtered.count) persons")
        return filtered
    }
    
    func getUpcomingBirthdays() -> [Person] {
        let calendar = Calendar.current
        let today = Date()
        let currentMonth = calendar.component(.month, from: today)
        let currentDay = calendar.component(.day, from: today)
        
        print("getUpcomingBirthdays: current month=\(currentMonth), day=\(currentDay)")
        print("Total persons: \(persons.count)")
        
        let filtered = persons.filter { person in
            let personMonth = Int(person.birthMonth)
            let personDay = Int(person.birthDay)
            
            print("Person: \(person.name), month: \(personMonth), day: \(personDay)")
            
            if personMonth == currentMonth {
                return personDay >= currentDay
            } else if personMonth > currentMonth {
                return true
            }
            return false
        }.sorted { first, second in
            if first.birthMonth == second.birthMonth {
                return first.birthDay < second.birthDay
            }
            return first.birthMonth < second.birthMonth
        }
        
        print("Upcoming birthdays count: \(filtered.count)")
        return filtered
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}
