//
//  CalendarView.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var personViewModel: PersonViewModel
    @Binding var currentDate: Date
    @State private var showingAddPerson = false
    @State private var selectedDate: Date?
    @State private var showingPersonList = false
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    private let weekdays = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    
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
                    // Debug info
                    Text("Persons count: \(personViewModel.persons.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                    
                    // Header with month navigation
                    VStack(spacing: 16) {
                        HStack {
                            Button(action: previousMonth) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(Color.appPrimary)
                                            .shadow(color: Color.appPrimary.opacity(0.3), radius: 4, x: 0, y: 2)
                                    )
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentDate)
                            
                            Spacer()
                            
                            VStack(spacing: 4) {
                                Text(dateFormatter.string(from: currentDate))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("birthday_tracker".localized())
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: nextMonth) {
                                Image(systemName: "chevron.right")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(Color.appPrimary)
                                            .shadow(color: Color.appPrimary.opacity(0.3), radius: 4, x: 0, y: 2)
                                    )
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: currentDate)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }
                
                    // Weekday headers
                    HStack(spacing: 0) {
                        ForEach(weekdays, id: \.self) { weekday in
                            Text(weekday.localized())
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.appPrimary.opacity(0.1))
                                )
                                .padding(.horizontal, 2)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                    // Calendar container
                    VStack(spacing: 0) {
                        // Calendar grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 8) {
                            ForEach(daysInMonth, id: \.self) { date in
                                if let date = date {
                                    CalendarDayView(
                                        date: date,
                                        persons: personViewModel.getPersonsForDate(
                                            day: calendar.component(.day, from: date),
                                            month: calendar.component(.month, from: date)
                                        ),
                                        isToday: calendar.isDateInToday(date),
                                        isSelected: selectedDate == date
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedDate = date
                                            showingPersonList = true
                                        }
                                    }
                                } else {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(height: 50)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        )
                        .padding(.horizontal, 16)
                    }
                
                    Spacer()
                    
                    // Add person button
                    Button(action: { 
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showingAddPerson = true 
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                            Text("add_person".localized())
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("birthday_tracker".localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPerson = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddPerson) {
            AddPersonView()
                .environmentObject(personViewModel)
        }
        .onAppear {
            // Force refresh when view appears
            personViewModel.fetchPersons()
        }
        .sheet(isPresented: $showingPersonList) {
            if let selectedDate = selectedDate {
                PersonListView(
                    date: selectedDate,
                    persons: personViewModel.getPersonsForDate(
                        day: calendar.component(.day, from: selectedDate),
                        month: calendar.component(.month, from: selectedDate)
                    )
                )
                .environmentObject(personViewModel)
            }
        }
    }
    
    private var daysInMonth: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else {
            return []
        }
        
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let adjustedFirstWeekday = firstWeekday == 1 ? 7 : firstWeekday - 1 // Convert Sunday=1 to Monday=1
        
        var days: [Date?] = Array(repeating: nil, count: adjustedFirstWeekday - 1)
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = newDate
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let persons: [Person]
    let isToday: Bool
    let isSelected: Bool
    let action: () -> Void
    
    private let calendar = Calendar.current
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(dayFormatter.string(from: date))
                    .font(.system(size: 16, weight: isToday ? .bold : .semibold))
                    .foregroundColor(isToday ? .white : (isSelected ? .white : .primary))
                
                if !persons.isEmpty {
                    HStack(spacing: 3) {
                        ForEach(persons.prefix(3), id: \.id) { _ in
                            Circle()
                                .fill(isToday ? .white : Color.appPrimary)
                                .frame(width: 5, height: 5)
                        }
                        if persons.count > 3 {
                            Text("+\(persons.count - 3)")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(isToday ? .white : Color.appPrimary)
                        }
                    }
                }
            }
            .frame(width: 50, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isToday ? 
                        LinearGradient(
                            colors: [Color.appPrimary, Color.appPrimary.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        (isSelected ? 
                         LinearGradient(
                             colors: [Color.appPrimary.opacity(0.2), Color.appPrimary.opacity(0.1)],
                             startPoint: .topLeading,
                             endPoint: .bottomTrailing
                         ) :
                         LinearGradient(
                             colors: [Color.clear, Color.clear],
                             startPoint: .topLeading,
                             endPoint: .bottomTrailing
                         ))
                    )
                    .shadow(
                        color: isToday ? Color.appPrimary.opacity(0.3) : Color.clear,
                        radius: isToday ? 4 : 0,
                        x: 0,
                        y: isToday ? 2 : 0
                    )
            )
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CalendarView(currentDate: .constant(Date()))
        .environmentObject(PersonViewModel())
}
