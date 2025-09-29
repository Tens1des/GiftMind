//
//  SettingsView.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var showingUsernameEditor = false
    @State private var showingAvatarPicker = false
    @State private var tempUsername = ""
    
    private let avatars = [
        "person.circle", "person.circle.fill", "person.2.circle",
        "person.2.circle.fill", "person.crop.circle", "person.crop.circle.fill",
        // extra avatars
        "person", "person.fill", "person.2", "person.2.fill",
        "person.crop.square", "person.crop.square.fill"
    ]
    
    private let languages = [
        ("en", "English"),
        ("ru", "Русский")
    ]
    
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
                
                if settingsViewModel.isLoading {
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
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Header
                            VStack(spacing: 16) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("settings".localized())
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                        
                                        Text("customize your experience".localized())
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 8)
                            }
                            
                            // Profile Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "person.circle.fill")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.headline)
                                    Text("profile".localized())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal, 20)
                                
                                VStack(spacing: 12) {
                                    // Avatar
                                    Button(action: { showingAvatarPicker = true }) {
                                        HStack(spacing: 16) {
                                            ZStack {
                                                Circle()
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                    .frame(width: 60, height: 60)
                                                    .shadow(color: Color.appPrimary.opacity(0.3), radius: 6, x: 0, y: 3)
                                                
                                                Image(systemName: settingsViewModel.userSettings?.avatar ?? "person.circle")
                                                    .font(.title2)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("avatar".localized())
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.primary)
                                                
                                                Text("tap to change".localized())
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color(.systemBackground))
                                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    // Username
                                    Button(action: {
                                        tempUsername = settingsViewModel.userSettings?.username ?? "User"
                                        showingUsernameEditor = true
                                    }) {
                                        HStack(spacing: 16) {
                                            Image(systemName: "person.fill")
                                                .foregroundColor(Color.appPrimary)
                                                .font(.title2)
                                                .frame(width: 30)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("username".localized())
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.primary)
                                                
                                                Text(settingsViewModel.userSettings?.username ?? "User")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color(.systemBackground))
                                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Appearance Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "paintbrush.fill")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.headline)
                                    Text("appearance".localized())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal, 20)
                                
                                // Dark Mode
                                HStack(spacing: 16) {
                                    Image(systemName: "moon.fill")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.title2)
                                        .frame(width: 30)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("dark theme".localized())
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        
                                        Text("switch theme mode".localized())
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { settingsViewModel.userSettings?.isDarkMode ?? false },
                                        set: { settingsViewModel.updateTheme(isDarkMode: $0) }
                                    ))
                                    .tint(Color.appPrimary)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                                )
                            }
                            .padding(.horizontal, 20)
                            
                            // Language Section
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "globe")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.headline)
                                    Text("language".localized())
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal, 20)
                                
                                HStack(spacing: 16) {
                                    Image(systemName: "textformat")
                                        .foregroundColor(Color.appPrimary)
                                        .font(.title2)
                                        .frame(width: 30)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("interface language".localized())
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        
                                        Text("choose app language".localized())
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Menu {
                                        ForEach(languages, id: \.0) { language in
                                            Button(language.1) {
                                                settingsViewModel.updateLanguage(language.0)
                                            }
                                        }
                                    } label: {
                                        HStack(spacing: 4) {
                                            Text(languages.first(where: { $0.0 == (settingsViewModel.userSettings?.language ?? "en") })?.1 ?? "English")
                                                .font(.subheadline)
                                                .foregroundColor(.primary)
                                            Image(systemName: "chevron.down")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
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
                            }
                            .padding(.horizontal, 20)
                            
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingUsernameEditor) {
            UsernameEditorView(
                currentUsername: tempUsername,
                onSave: { newUsername in
                    settingsViewModel.updateUsername(newUsername)
                    showingUsernameEditor = false
                },
                onCancel: {
                    showingUsernameEditor = false
                }
            )
        }
        .sheet(isPresented: $showingAvatarPicker) {
            AvatarPickerView(
                currentAvatar: settingsViewModel.userSettings?.avatar ?? "person.circle",
                avatars: avatars,
                onSelect: { selectedAvatar in
                    settingsViewModel.updateAvatar(selectedAvatar)
                    showingAvatarPicker = false
                },
                onCancel: {
                    showingAvatarPicker = false
                }
            )
        }
        .onAppear {
            if settingsViewModel.userSettings == nil {
                settingsViewModel.fetchUserSettings()
            }
        }
    }
}

struct UsernameEditorView: View {
    @State private var username: String
    let onSave: (String) -> Void
    let onCancel: () -> Void
    
    init(currentUsername: String, onSave: @escaping (String) -> Void, onCancel: @escaping () -> Void) {
        _username = State(initialValue: currentUsername)
        self.onSave = onSave
        self.onCancel = onCancel
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
                            
                            Image(systemName: "person.crop.circle.badge.checkmark")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text("edit".localized() + " " + "username".localized())
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("choose your username".localized())
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Form content
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color.appPrimary)
                                .font(.headline)
                            Text("username".localized())
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        TextField("username".localized(), text: $username)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 100)
                }
                
                // Bottom buttons
                VStack {
                    Spacer()
                    
                    HStack(spacing: 16) {
                        // Cancel button
                        Button(action: onCancel) {
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
                        Button(action: { onSave(username) }) {
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
                                        username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
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
                                        color: username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                                        Color.clear : 
                                        Color.appPrimary.opacity(0.3),
                                        radius: 8, x: 0, y: 4
                                    )
                            )
                        }
                        .disabled(username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .scaleEffect(username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.95 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: username.isEmpty)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct AvatarPickerView: View {
    let currentAvatar: String
    let avatars: [String]
    let onSelect: (String) -> Void
    let onCancel: () -> Void
    
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
                
                VStack(spacing: 16) {
                    // Header
                    VStack(spacing: 12) {
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
                                .frame(width: 56, height: 56)
                                .shadow(color: Color.appPrimary.opacity(0.3), radius: 6, x: 0, y: 3)
                            
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text("select".localized() + " " + "avatar".localized())
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("choose your avatar".localized())
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 8)
                    
                    // Avatar grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                        ForEach(avatars, id: \.self) { avatar in
                            Button(action: { onSelect(avatar) }) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            currentAvatar == avatar ?
                                            LinearGradient(
                                                colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ) :
                                            LinearGradient(
                                                colors: [Color.appPrimary.opacity(0.1), Color.appPrimary.opacity(0.05)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 64, height: 64)
                                        .shadow(
                                            color: currentAvatar == avatar ? Color.appPrimary.opacity(0.3) : Color.clear,
                                            radius: currentAvatar == avatar ? 6 : 0,
                                            x: 0,
                                            y: currentAvatar == avatar ? 3 : 0
                                        )
                                    
                                    Image(systemName: avatar)
                                        .font(.system(size: 26, weight: .semibold))
                                        .foregroundColor(currentAvatar == avatar ? .white : Color.appPrimary)
                                    
                                    if currentAvatar == avatar {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                            .frame(width: 64, height: 64)
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .scaleEffect(currentAvatar == avatar ? 1.06 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentAvatar)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 12)
                }
                
                // Bottom button
                VStack {
                    Spacer()
                    
                    Button(action: onCancel) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark")
                            Text("cancel".localized())
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
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
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
}
