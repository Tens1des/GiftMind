//
//  ThemeManager.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var isDarkMode: Bool = false
    @Published var colorScheme: String = "purple"
    
    private init() {
        // Load saved theme settings
        isDarkMode = UserDefaults.standard.bool(forKey: "is_dark_mode")
        colorScheme = UserDefaults.standard.string(forKey: "color_scheme") ?? "purple"
    }
    
    func setDarkMode(_ isDark: Bool) {
        isDarkMode = isDark
        UserDefaults.standard.set(isDark, forKey: "is_dark_mode")
    }
    
    func setColorScheme(_ scheme: String) {
        colorScheme = scheme
        UserDefaults.standard.set(scheme, forKey: "color_scheme")
    }
    
    var primaryColor: Color {
        switch colorScheme {
        case "blue":
            return .blue
        case "green":
            return .green
        case "orange":
            return .orange
        default:
            return .purple
        }
    }
    
    var gradientColors: [Color] {
        switch colorScheme {
        case "blue":
            return [.blue, .cyan]
        case "green":
            return [.green, .mint]
        case "orange":
            return [.orange, .yellow]
        default:
            return [.purple, .pink]
        }
    }
}

extension Color {
    static var appPrimary: Color {
        ThemeManager.shared.primaryColor
    }
    
    static var appGradient: [Color] {
        ThemeManager.shared.gradientColors
    }
}

