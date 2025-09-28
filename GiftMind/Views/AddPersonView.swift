//
//  AddPersonView.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import SwiftUI

struct AddPersonView: View {
    @EnvironmentObject var personViewModel: PersonViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedDay = 1
    @State private var selectedMonth = 1
    @State private var interests = ""
    @State private var giftIdeas = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private let months = [
        (1, "January"), (2, "February"), (3, "March"), (4, "April"),
        (5, "May"), (6, "June"), (7, "July"), (8, "August"),
        (9, "September"), (10, "October"), (11, "November"), (12, "December")
    ]
    
    private var daysInSelectedMonth: Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        let dateComponents = DateComponents(year: year, month: selectedMonth)
        if let date = calendar.date(from: dateComponents) {
            return calendar.range(of: .day, in: .month, for: date)?.count ?? 31
        }
        return 31
    }
    
    var body: some View {
        NavigationView {
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
                        // Header
                        VStack(spacing: 16) {
                            // Icon
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                    .shadow(color: Color.appPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                Image(systemName: "person.badge.plus")
                                    .font(.system(size: 32, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 8) {
                                Text("add_person_title".localized())
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                                            }
                        }
                        .padding(.top, 20)
                        
                        // Form content
                        VStack(spacing: 20) {
                            // Name field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.headline)
                                    Text("personal_information".localized())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                
                                TextField("name".localized(), text: $name)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            // Birthday section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.headline)
                                    Text("birthday".localized())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                
                                HStack(spacing: 16) {
                                    // Month picker
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("month".localized())
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        Menu {
                                            ForEach(months, id: \.0) { month in
                                                Button(month.1) {
                                                    selectedMonth = month.0
                                                }
                                            }
                                        } label: {
                                            HStack {
                                                Text(months.first(where: { $0.0 == selectedMonth })?.1 ?? "January")
                                                    .foregroundColor(.primary)
                                                Spacer()
                                                Image(systemName: "chevron.down")
                                                    .foregroundColor(.secondary)
                                                    .font(.caption)
                                            }
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color(.systemBackground))
                                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                            )
                                        }
                                    }
                                    
                                    // Day picker
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("day".localized())
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        Menu {
                                            ForEach(1...daysInSelectedMonth, id: \.self) { day in
                                                Button("\(day)") {
                                                    selectedDay = day
                                                }
                                            }
                                        } label: {
                                            HStack {
                                                Text("\(selectedDay)")
                                                    .foregroundColor(.primary)
                                                Spacer()
                                                Image(systemName: "chevron.down")
                                                    .foregroundColor(.secondary)
                                                    .font(.caption)
                                            }
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color(.systemBackground))
                                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                            )
                                        }
                                    }
                                }
                            }
                            
                            // Interests field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.headline)
                                    Text("interests".localized())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Text("(Optional)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                TextField("interests_placeholder".localized(), text: $interests, axis: .vertical)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .lineLimit(3...6)
                            }
                            
                            // Gift ideas field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "gift.fill")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.headline)
                                    Text("gift_ideas".localized())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Text("(Optional)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                TextField("gift_ideas_placeholder".localized(), text: $giftIdeas, axis: .vertical)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .lineLimit(3...6)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
                
                // Bottom buttons
                VStack {
                    Spacer()
                    
                    HStack(spacing: 16) {
                        // Cancel button
                        Button(action: { dismiss() }) {
                            HStack {
                                Image(systemName: "xmark")
                                Text("cancel".localized())
                            }
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemGray6))
                            )
                        }
                        
                        // Save button
                        Button(action: savePerson) {
                            HStack {
                                Image(systemName: "checkmark")
                                Text("save".localized())
                            }
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                                        LinearGradient(
                                            colors: [Color.gray, Color.gray.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ) :
                                        LinearGradient(
                                            colors: Color.appGradient,
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(
                                        color: name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                                        Color.clear : 
                                        Color.appPrimary.opacity(0.3),
                                        radius: 8, x: 0, y: 4
                                    )
                            )
                        }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .scaleEffect(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.95 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: name.isEmpty)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .alert("error".localized(), isPresented: $showingError) {
            Button("ok".localized()) { }
        } message: {
            Text(errorMessage)
        }
        .onChange(of: selectedMonth) { _ in
            // Adjust selected day if it's not valid for the new month
            if selectedDay > daysInSelectedMonth {
                selectedDay = daysInSelectedMonth
            }
        }
    }
    
    private func savePerson() {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter a name"
            showingError = true
            return
        }
        
        personViewModel.addPerson(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            birthDay: selectedDay,
            birthMonth: selectedMonth,
            interests: interests.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : interests.trimmingCharacters(in: .whitespacesAndNewlines),
            giftIdeas: giftIdeas.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : giftIdeas.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        dismiss()
    }
}

// Custom TextField Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appPrimary.opacity(0.2), lineWidth: 1)
            )
    }
}

#Preview {
    AddPersonView()
        .environmentObject(PersonViewModel())
}
