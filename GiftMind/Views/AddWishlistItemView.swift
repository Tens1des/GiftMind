//
//  AddWishlistItemView.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import SwiftUI

struct AddWishlistItemView: View {
    @EnvironmentObject var wishlistViewModel: WishlistViewModel
    @Environment(\.dismiss) private var dismiss
    
    let person: Person
    
    @State private var title = ""
    @State private var url = ""
    @State private var price = ""
    @State private var store = ""
    @State private var category = ""
    @State private var selectedPriority = "medium"
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private let priorities = [
        ("low", "Low", Color.green),
        ("medium", "Medium", Color.orange),
        ("high", "High", Color.red)
    ]
    
    private let categories = [
        "Electronics", "Clothing", "Books", "Kitchen", "Sports",
        "Beauty", "Home", "Toys", "Jewelry", "Other"
    ]
    
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
                                
                                Image(systemName: "gift.fill")
                                    .font(.system(size: 32, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 8) {
                                Text("add_wishlist_item".localized())
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
                            // Gift name field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "gift.fill")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.headline)
                                    Text("gift_details".localized())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                
                                TextField("gift_name".localized(), text: $title)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            // Price and Store section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "dollarsign.circle.fill")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.headline)
                                    Text("price and store".localized())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                
                                HStack(spacing: 16) {
                                    // Price field
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("price".localized())
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        TextField("price".localized(), text: $price)
                                            .textFieldStyle(CustomTextFieldStyle())
                                            .keyboardType(.decimalPad)
                                    }
                                    
                                    // Store field
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("store".localized())
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        TextField("store".localized(), text: $store)
                                            .textFieldStyle(CustomTextFieldStyle())
                                    }
                                }
                            }
                            
                            // Category and Priority section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "tag.fill")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.headline)
                                    Text("category and priority".localized())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                
                                HStack(spacing: 16) {
                                    // Category picker
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("category".localized())
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        Menu {
                                            Button("select".localized()) {
                                                category = ""
                                            }
                                            ForEach(categories, id: \.self) { cat in
                                                Button(cat) {
                                                    category = cat
                                                }
                                            }
                                        } label: {
                                            HStack {
                                                Text(category.isEmpty ? "select".localized() : category)
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
                                    
                                    // Priority picker
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("priority".localized())
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        Menu {
                                            ForEach(priorities, id: \.0) { priority in
                                                Button {
                                                    selectedPriority = priority.0
                                                } label: {
                                                    HStack {
                                                        Circle()
                                                            .fill(priority.2)
                                                            .frame(width: 8, height: 8)
                                                        Text(priority.1)
                                                    }
                                                }
                                            }
                                        } label: {
                                            HStack {
                                                Circle()
                                                    .fill(priorities.first(where: { $0.0 == selectedPriority })?.2 ?? Color.gray)
                                                    .frame(width: 8, height: 8)
                                                Text(priorities.first(where: { $0.0 == selectedPriority })?.1 ?? "Medium")
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
                            
                            // URL field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "link")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.headline)
                                    Text("link_optional".localized())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Text("(Optional)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                TextField("link_optional".localized(), text: $url)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .keyboardType(.URL)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
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
                        Button(action: saveWishlistItem) {
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
                                        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
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
                                        color: title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                                        Color.clear : 
                                        Color.appPrimary.opacity(0.3),
                                        radius: 8, x: 0, y: 4
                                    )
                            )
                        }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .scaleEffect(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.95 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: title.isEmpty)
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
    }
    
    private func saveWishlistItem() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please enter a gift name"
            showingError = true
            return
        }
        
        let trimmedUrl = url.trimmingCharacters(in: .whitespacesAndNewlines)
        let validUrl = trimmedUrl.isEmpty ? nil : (URL(string: trimmedUrl) != nil ? trimmedUrl : nil)
        
        if !trimmedUrl.isEmpty && validUrl == nil {
            errorMessage = "Please enter a valid URL"
            showingError = true
            return
        }
        
        wishlistViewModel.addWishlistItem(
            to: person,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            url: validUrl,
            price: price.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : price.trimmingCharacters(in: .whitespacesAndNewlines),
            store: store.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : store.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category.isEmpty ? nil : category,
            priority: selectedPriority
        )
        
        dismiss()
    }
}

#Preview {
    AddWishlistItemView(person: Person())
        .environmentObject(WishlistViewModel())
}
