//
//  UpcomingView.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import SwiftUI

struct UpcomingView: View {
    @EnvironmentObject var personViewModel: PersonViewModel
    @State private var showingAddPerson = false
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemBackground).opacity(0.8),
                        Color.appPrimary.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 16) {
                        // Debug info
                        Text("Total persons: \(personViewModel.persons.count), Upcoming: \(upcomingBirthdays.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                        
                        // Title section
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("upcoming".localized())
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                
                            }
                            
                            Spacer()
                            
                            // Add button
                            Button(action: { 
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    showingAddPerson = true 
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.appPrimary, Color.appPrimary.opacity(0.8)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 50, height: 50)
                                        .shadow(color: Color.appPrimary.opacity(0.3), radius: 6, x: 0, y: 3)
                                    
                                    Image(systemName: "plus")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingAddPerson)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }
                    
                    // Content
                    if personViewModel.isLoading {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            ProgressView()
                                .scaleEffect(1.2)
                                .tint(Color.appPrimary)
                            
                            Text("loading".localized())
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if upcomingBirthdays.isEmpty {
                        VStack(spacing: 24) {
                            Spacer()
                            
                            // Empty state
                            VStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.appPrimary.opacity(0.1), Color.appPrimary.opacity(0.05)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: "calendar.badge.plus")
                                        .font(.system(size: 50, weight: .medium))
                                        .foregroundColor(Color.appPrimary.opacity(0.6))
                                }
                                
                                VStack(spacing: 12) {
                                    Text("no_upcoming_birthdays".localized())
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    Text("add_people_to_start".localized())
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 20)
                                }
                                
                                Button(action: { 
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        showingAddPerson = true 
                                    }
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title3)
                                        Text("add_first_person".localized())
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                    }
                                    .foregroundColor(.white)
                                    .padding(.vertical, 16)
                                    .padding(.horizontal, 32)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(
                                                LinearGradient(
                                                    colors: Color.appGradient,
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .shadow(color: Color.appPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                                    )
                                }
                                .scaleEffect(1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingAddPerson)
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // List of upcoming birthdays
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(upcomingBirthdays, id: \.id) { person in
                                    NavigationLink(destination: PersonDetailView(person: person)) {
                                        UpcomingBirthdayRow(person: person)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddPerson) {
            AddPersonView()
                .environmentObject(personViewModel)
        }
        .onAppear {
            // Force refresh when view appears
            personViewModel.fetchPersons()
        }
    }
    
    private var upcomingBirthdays: [Person] {
        personViewModel.getUpcomingBirthdays()
    }
}

struct UpcomingBirthdayRow: View {
    let person: Person
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
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
        HStack(spacing: 16) {
            // Avatar/Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .shadow(color: Color.appPrimary.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Text(String(person.name.prefix(1)).uppercased())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // Person info
            VStack(alignment: .leading, spacing: 6) {
                Text(person.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(dateFormatter.string(from: createBirthdayDate()))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let interests = person.interests, !interests.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                            .font(.caption2)
                            .foregroundColor(Color.appPrimary.opacity(0.7))
                        
                        Text(interests)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            // Days until birthday
            VStack(alignment: .trailing, spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            daysUntilBirthday <= 7 ?
                            LinearGradient(
                                colors: [Color.orange, Color.orange.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [Color.appPrimary, Color.appPrimary.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 40)
                        .shadow(
                            color: (daysUntilBirthday <= 7 ? Color.orange : Color.appPrimary).opacity(0.3),
                            radius: 4, x: 0, y: 2
                        )
                    
                    VStack(spacing: 2) {
                        Text("\(daysUntilBirthday)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("days".localized(daysUntilBirthday))
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                
                if daysUntilBirthday <= 7 {
                    Text("soon".localized())
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color.orange.opacity(0.1))
                        )
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

#Preview {
    UpcomingView()
        .environmentObject(PersonViewModel())
}
