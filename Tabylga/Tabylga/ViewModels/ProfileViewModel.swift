import Foundation
import SwiftUI
import Observation

@Observable
@MainActor
class ProfileViewModel {
    private let apiClient: TabylgaAPIClient
    var profile: UserProfile
    var achievements: [Achievement]
    var highlightedAchievement: Achievement

    init(apiClient: TabylgaAPIClient = .shared) {
        self.apiClient = apiClient
        self.profile = MockData.userProfile
        self.achievements = MockData.achievements
        self.highlightedAchievement = MockData.legendaryAchievement

        Task { await refreshFromAPIIfConfigured() }
    }

    var unlockedCount: Int { achievements.filter(\.isUnlocked).count }
    var totalCount: Int { achievements.count }
    var unlockProgress: Double { Double(unlockedCount) / Double(max(totalCount, 1)) }

    func refreshFromAPIIfConfigured() async {
        guard apiClient.isConfigured else { return }

        do {
            async let profileResponse = apiClient.fetchProfile()
            async let achievementsResponse = apiClient.fetchAchievements()

            let profilePayload = try await profileResponse
            let achievementsPayload = try await achievementsResponse
            let fetchedProfile = profilePayload.toModel()
            let fetchedAchievements = achievementsPayload.map { $0.toModel() }

            self.profile = fetchedProfile
            if !fetchedAchievements.isEmpty {
                self.achievements = fetchedAchievements
                self.highlightedAchievement =
                    fetchedAchievements.first(where: { $0.rarity == .legendary && $0.isUnlocked }) ??
                    fetchedAchievements[0]
            }
        } catch {
            // Preserve mock data as a silent fallback when the remote backend is unavailable.
        }
    }
}

private extension APIUserProfile {
    func toModel() -> UserProfile {
        UserProfile(
            id: id,
            name: name,
            level: levelLabel,
            levelNumber: levelNumber,
            xp: stats.xp,
            xpToNextLevel: stats.xpToNext,
            journeysCompleted: journeysCompleted,
            badgesCollected: badgesCollected,
            kilometersTraced: stats.kilometers,
            totem: totem
        )
    }
}

private extension APIAchievement {
    func toModel() -> Achievement {
        Achievement(
            id: id,
            title: title,
            subtitle: subtitle,
            era: era,
            symbol: symbol,
            isUnlocked: isUnlocked,
            rarity: AchievementRarity(rawValue: rarity) ?? .common
        )
    }
}
