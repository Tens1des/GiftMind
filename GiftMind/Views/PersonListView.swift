//
//  PersonListView.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import SwiftUI

struct PersonListView: View {
    @EnvironmentObject var personViewModel: PersonViewModel
    @Environment(\.dismiss) private var dismiss
    
    let date: Date
    let persons: [Person]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                if persons.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(Color.appPrimary.opacity(0.6))
                        
                        Text("no_birthdays_on_date".localized(dateFormatter.string(from: date)))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Text("add_people_to_start".localized())
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(persons, id: \.id) { person in
                            NavigationLink(destination: PersonDetailView(person: person)) {
                                PersonRow(person: person)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle(dateFormatter.string(from: date))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("done".localized()) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PersonRow: View {
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
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(person.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(dateFormatter.string(from: createBirthdayDate()))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let interests = person.interests, !interests.isEmpty {
                    Text(interests)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                if daysUntilBirthday == 0 {
                    Text("today".localized())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                } else {
                    Text("days".localized(daysUntilBirthday))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.appPrimary)
                }
                
                if daysUntilBirthday <= 7 && daysUntilBirthday > 0 {
                    Text("soon".localized())
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 4)
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
    PersonListView(
        date: Date(),
        persons: []
    )
    .environmentObject(PersonViewModel())
}
