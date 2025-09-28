//
//  ContentView.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var personViewModel = PersonViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var achievementViewModel = AchievementViewModel()
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var selectedTab = 0
    @State private var currentDate = Date()
    @State private var isCoreDataReady = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CalendarView(currentDate: $currentDate)
                .environmentObject(personViewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("calendar".localized())
                }
                .tag(0)
            
            UpcomingView()
                .environmentObject(personViewModel)
                .tabItem {
                    Image(systemName: "clock")
                    Text("upcoming".localized())
                }
                .tag(1)
            
            AchievementsView()
                .environmentObject(achievementViewModel)
                .tabItem {
                    Image(systemName: "trophy")
                    Text("achievements".localized())
                }
                .tag(2)
            
            SettingsView()
                .environmentObject(settingsViewModel)
                .tabItem {
                    Image(systemName: "gear")
                    Text("settings".localized())
                }
                .tag(3)
        }
        .accentColor(themeManager.primaryColor)
        .preferredColorScheme(settingsViewModel.userSettings?.isDarkMode == true ? .dark : .light)
        .onAppear {
            // ViewModels are now initialized automatically
            settingsViewModel.fetchUserSettings()
        }
        .onChange(of: settingsViewModel.userSettings?.isDarkMode) { isDarkMode in
            // Force UI update when theme changes
            print("Theme changed to: \(isDarkMode == true ? "Dark" : "Light")")
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
