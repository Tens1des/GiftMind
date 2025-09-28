//
//  AchievementsView.swift
//  GiftMind
//
//  Created by Рома Котов on 27.09.2025.
//

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var achievementViewModel: AchievementViewModel
    @State private var selectedAchievement: Achievement?
    
    private var completedAchievements: [Achievement] {
        achievementViewModel.achievements.filter { $0.isCompleted }
    }
    
    private var pendingAchievements: [Achievement] {
        achievementViewModel.achievements.filter { !$0.isCompleted }
    }
    
    private var totalXP: Int {
        completedAchievements.reduce(0) { $0 + Int($1.xpReward) }
    }
    
    private var completedCount: Int {
        completedAchievements.count
    }
    
    private var totalCount: Int {
        achievementViewModel.achievements.count
    }
    
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
                    // Header section
                    VStack(spacing: 20) {
                        // Title
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("achievements".localized())
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("track your progress".localized())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        // Level and XP card
                        VStack(spacing: 16) {
                            HStack(spacing: 20) {
                                // Level display
                                VStack(spacing: 8) {
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
                                        
                                        Text("\(calculateLevel())")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text("level".localized(calculateLevel()))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                // XP and progress
                                VStack(alignment: .trailing, spacing: 12) {
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("\(totalXP)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.primary)
                                        
                                        Text("total xp".localized())
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("\(completedCount)/\(totalCount)")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.appPrimary)
                                        
                                        Text("achievements completed".localized())
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            
                            // Progress bar
                            VStack(spacing: 8) {
                                HStack {
                                    Text("progress".localized())
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text("\(Int((Double(completedCount) / Double(totalCount)) * 100))%")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.appPrimary)
                                }
                                
                                if totalCount > 0 {
                                    ProgressView(value: Double(completedCount), total: Double(totalCount))
                                        .progressViewStyle(LinearProgressViewStyle(tint: Color.appPrimary))
                                        .scaleEffect(x: 1, y: 2, anchor: .center)
                                } else {
                                    ProgressView(value: 0, total: 1)
                                        .progressViewStyle(LinearProgressViewStyle(tint: Color.appPrimary))
                                        .scaleEffect(x: 1, y: 2, anchor: .center)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    // Content
                    if achievementViewModel.isLoading {
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
                            LazyVStack(spacing: 16) {
                                // Completed achievements
                                if !completedAchievements.isEmpty {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.headline)
                                            Text("completed".localized() + " (\(completedCount))")
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                        }
                                        .padding(.horizontal, 20)
                                        
                                        ForEach(completedAchievements, id: \.id) { achievement in
                                            AchievementRow(achievement: achievement, isCompleted: true)
                                                .onTapGesture {
                                                    selectedAchievement = achievement
                                                }
                                        }
                                    }
                                }
                                
                                // Pending achievements
                                if !pendingAchievements.isEmpty {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Image(systemName: "clock.fill")
                                                .foregroundColor(.orange)
                                                .font(.headline)
                                            Text("in_progress".localized() + " (\(pendingAchievements.count))")
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                        }
                                        .padding(.horizontal, 20)
                                        
                                        ForEach(pendingAchievements, id: \.id) { achievement in
                                            AchievementRow(achievement: achievement, isCompleted: false)
                                                .onTapGesture {
                                                    selectedAchievement = achievement
                                                }
                                        }
                                    }
                                }
                                
                                Spacer(minLength: 100)
                            }
                            .padding(.vertical, 16)
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(item: $selectedAchievement) { achievement in
            AchievementDetailView(achievement: achievement)
        }
        .onAppear {
            achievementViewModel.checkAchievements()
        }
    }
    
    private func calculateLevel() -> Int {
        if totalXP <= 0 {
            return 1
        }
        return (totalXP / 100) + 1
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    let isCompleted: Bool
    
    private var categoryColor: Color {
        switch achievement.category {
        case "common":
            return .gray
        case "uncommon":
            return .green
        case "rare":
            return .blue
        case "legendary":
            return .purple
        default:
            return .gray
        }
    }
    
    private var categoryIcon: String {
        switch achievement.category {
        case "common":
            return "star.fill"
        case "uncommon":
            return "star.circle.fill"
        case "rare":
            return "star.square.fill"
        case "legendary":
            return "crown.fill"
        default:
            return "star.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        isCompleted ?
                        LinearGradient(
                            colors: [categoryColor, categoryColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [categoryColor.opacity(0.3), categoryColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(
                        color: isCompleted ? categoryColor.opacity(0.3) : Color.clear,
                        radius: isCompleted ? 6 : 0,
                        x: 0,
                        y: isCompleted ? 3 : 0
                    )
                
                Image(systemName: categoryIcon)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(isCompleted ? .white : categoryColor)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(achievement.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(isCompleted ? .primary : .secondary)
                    .lineLimit(2)
                
                Text(achievement.achievementDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    // XP reward
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(Color.appPrimary)
                        
                        Text("xp_reward".localized(Int(achievement.xpReward)))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.appPrimary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.appPrimary.opacity(0.1))
                    )
                    
                    Spacer()
                    
                    // Status
                    if isCompleted {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                            
                            Text("completed".localized())
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.green.opacity(0.1))
                        )
                    } else {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.caption)
                                .foregroundColor(.orange)
                            
                            Text("in_progress".localized())
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.orange.opacity(0.1))
                        )
                    }
                }
            }
            
            Spacer()
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
                    isCompleted ? 
                    categoryColor.opacity(0.3) : 
                    Color.gray.opacity(0.1),
                    lineWidth: 1
                )
        )
        .opacity(isCompleted ? 1.0 : 0.8)
        .scaleEffect(isCompleted ? 1.0 : 0.98)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCompleted)
    }
}

struct AchievementDetailView: View {
    let achievement: Achievement
    @Environment(\.dismiss) private var dismiss
    
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
                        VStack(spacing: 20) {
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
                                    .frame(width: 120, height: 120)
                                    .shadow(color: Color.appPrimary.opacity(0.3), radius: 12, x: 0, y: 6)
                                
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 50, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 12) {
                                Text(achievement.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.appPrimary, Color.appPrimary.opacity(0.7)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text(achievement.achievementDescription)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 20)
                        
                        // Stats cards
                        VStack(spacing: 16) {
                            // XP Reward card
                            HStack(spacing: 20) {
                                VStack(spacing: 8) {
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
                                        
                                        Image(systemName: "star.fill")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text("\(achievement.xpReward)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    Text("xp_reward_label".localized())
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [achievement.isCompleted ? Color.green : Color.orange, 
                                                            (achievement.isCompleted ? Color.green : Color.orange).opacity(0.7)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 60, height: 60)
                                            .shadow(
                                                color: (achievement.isCompleted ? Color.green : Color.orange).opacity(0.3),
                                                radius: 6, x: 0, y: 3
                                            )
                                        
                                        Image(systemName: achievement.isCompleted ? "checkmark.circle.fill" : "clock.fill")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text(achievement.isCompleted ? "completed".localized() : "in_progress".localized())
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(achievement.isCompleted ? .green : .orange)
                                    
                                    Text("status".localized())
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
                
                // Bottom button
                VStack {
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark")
                            Text("done".localized())
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    AchievementsView()
}
