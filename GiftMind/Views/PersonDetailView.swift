//
//  PersonDetailView.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import SwiftUI

struct PersonDetailView: View {
    @EnvironmentObject var personViewModel: PersonViewModel
    @StateObject private var wishlistViewModel = WishlistViewModel()
    @State private var showingEditPerson = false
    @State private var showingAddWishlistItem = false
    
    let person: Person
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }()
    
    private var daysUntilBirthday: Int {
        let today = Date()
        let currentYear = calendar.component(.year, from: today)
        
        var birthdayComponents = DateComponents()
        birthdayComponents.year = currentYear
        birthdayComponents.month = Int(person.birthMonth)
        birthdayComponents.day = Int(person.birthDay)
        
        guard let birthday = calendar.date(from: birthdayComponents) else { return 0 }
        
        if birthday < today {
            // Birthday already passed this year, check next year
            birthdayComponents.year = currentYear + 1
            guard let nextBirthday = calendar.date(from: birthdayComponents) else { return 0 }
            return calendar.dateComponents([.day], from: today, to: nextBirthday).day ?? 0
        } else {
            return calendar.dateComponents([.day], from: today, to: birthday).day ?? 0
        }
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0.9),
                    Color.appPrimary.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header section
                    VStack(spacing: 20) {
                        // Avatar and name
                        VStack(spacing: 16) {
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                    .shadow(color: Color.appPrimary.opacity(0.3), radius: 12, x: 0, y: 6)
                                
                                Text(String(person.name.prefix(1)).uppercased())
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 8) {
                                Text(person.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("\(dateFormatter.string(from: createBirthdayDate()))")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Days until birthday card
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("days_until_birthday".localized())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("\(daysUntilBirthday)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            if daysUntilBirthday <= 7 {
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("soon".localized())
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.orange)
                                    
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.title2)
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    daysUntilBirthday <= 7 ? 
                                    Color.orange.opacity(0.3) : 
                                    Color.appPrimary.opacity(0.1),
                                    lineWidth: 1
                                )
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Interests Section
                    if let interests = person.interests, !interests.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(Color.appPrimary)
                                    .font(.headline)
                                Text("interests".localized())
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            
                            Text(interests)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Gift Ideas Section
                    if let giftIdeas = person.giftIdeas, !giftIdeas.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(Color.appPrimary)
                                    .font(.headline)
                                Text("gift_ideas".localized())
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            
                            Text(giftIdeas)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Wishlist Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            HStack {
                                Image(systemName: "gift.fill")
                                    .foregroundColor(Color.appPrimary)
                                    .font(.headline)
                                Text("wishlist".localized())
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                            
                            Button(action: { 
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    showingAddWishlistItem = true 
                                }
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus")
                                        .font(.caption)
                                    Text("add_item".localized())
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            LinearGradient(
                                                colors: Color.appGradient,
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(color: Color.appPrimary.opacity(0.3), radius: 4, x: 0, y: 2)
                                )
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingAddWishlistItem)
                        }
                        .padding(.horizontal, 20)
                        
                        if wishlistViewModel.wishlistItems.isEmpty {
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.appPrimary.opacity(0.1), Color.appPrimary.opacity(0.05)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: "gift")
                                        .font(.system(size: 30, weight: .medium))
                                        .foregroundColor(Color.appPrimary.opacity(0.6))
                                }
                                
                                VStack(spacing: 8) {
                                    Text("no_wishlist_items".localized())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    
                                    Text("add_items_to_wishlist".localized())
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                
                                Button(action: { 
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        showingAddWishlistItem = true 
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title3)
                                        Text("add_first_item".localized())
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                    }
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                LinearGradient(
                                                    colors: Color.appGradient,
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .shadow(color: Color.appPrimary.opacity(0.3), radius: 6, x: 0, y: 3)
                                    )
                                }
                                .scaleEffect(1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingAddWishlistItem)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(wishlistViewModel.wishlistItems, id: \.id) { item in
                                    WishlistItemRow(item: item)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { 
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showingEditPerson = true 
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "pencil")
                            .font(.caption)
                        Text("edit".localized())
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: Color.appGradient,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: Color.appPrimary.opacity(0.3), radius: 4, x: 0, y: 2)
                    )
                }
                .scaleEffect(1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingEditPerson)
            }
        }
        .sheet(isPresented: $showingEditPerson) {
            EditPersonView(person: person)
                .environmentObject(personViewModel)
        }
        .sheet(isPresented: $showingAddWishlistItem) {
            AddWishlistItemView(person: person)
                .environmentObject(wishlistViewModel)
        }
        .onAppear {
            wishlistViewModel.fetchWishlistItems(for: person)
        }
    }
    
    private func createBirthdayDate() -> Date {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        var components = DateComponents()
        components.year = currentYear
        components.month = Int(person.birthMonth)
        components.day = Int(person.birthDay)
        
        return calendar.date(from: components) ?? Date()
    }
}

struct WishlistItemRow: View {
    let item: WishlistItem
    @State private var showingDeleteAlert = false
    
    private var priorityColor: Color {
        switch item.priority {
        case "high":
            return .red
        case "medium":
            return .orange
        case "low":
            return .green
        default:
            return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Circle()
                    .fill(priorityColor)
                    .frame(width: 8, height: 8)
            }
            
            if let price = item.price, !price.isEmpty {
                HStack {
                    Text("price".localized() + ":")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(price)
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
            
            if let store = item.store, !store.isEmpty {
                HStack {
                    Text("store".localized() + ":")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(store)
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
            
            if let url = item.url, !url.isEmpty {
                Button(action: {
                    if let url = URL(string: url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "link")
                        Text("open_link".localized())
                    }
                    .font(.caption)
                    .foregroundColor(Color.appPrimary)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .contextMenu {
            Button("delete".localized(), role: .destructive) {
                showingDeleteAlert = true
            }
        }
        .alert("delete_item".localized(), isPresented: $showingDeleteAlert) {
            Button("cancel".localized(), role: .cancel) { }
            Button("delete".localized(), role: .destructive) {
                // Delete logic would go here
            }
        } message: {
            Text("delete_item_confirmation".localized())
        }
    }
}

#Preview {
    NavigationView {
        PersonDetailView(person: Person())
    }
}
