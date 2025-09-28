//
//  WishlistViewModel.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import Foundation
import CoreData
import SwiftUI

class WishlistViewModel: ObservableObject {
    @Published var wishlistItems: [WishlistItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let persistenceController = PersistenceController.shared
    private var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    func fetchWishlistItems(for person: Person) {
        isLoading = true
        
        let request: NSFetchRequest<WishlistItem> = NSFetchRequest<WishlistItem>(entityName: "WishlistItem")
        request.predicate = NSPredicate(format: "person == %@", person)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WishlistItem.createdAt, ascending: false)]
        
        do {
            wishlistItems = try viewContext.fetch(request)
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch wishlist items: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func addWishlistItem(to person: Person, title: String, url: String?, price: String?, store: String?, category: String?, priority: String?) {
        let newItem = WishlistItem(context: viewContext)
        newItem.id = UUID()
        newItem.title = title
        newItem.url = url
        newItem.price = price
        newItem.store = store
        newItem.category = category
        newItem.priority = priority ?? "medium"
        newItem.createdAt = Date()
        newItem.person = person
        
        saveContext()
        fetchWishlistItems(for: person)
    }
    
    func updateWishlistItem(_ item: WishlistItem, title: String, url: String?, price: String?, store: String?, category: String?, priority: String?) {
        item.title = title
        item.url = url
        item.price = price
        item.store = store
        item.category = category
        item.priority = priority ?? "medium"
        
        saveContext()
        if let person = item.person {
            fetchWishlistItems(for: person)
        }
    }
    
    func deleteWishlistItem(_ item: WishlistItem) {
        viewContext.delete(item)
        saveContext()
        if let person = item.person {
            fetchWishlistItems(for: person)
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
