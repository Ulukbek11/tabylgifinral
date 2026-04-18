import Foundation

enum AchievementRarity: String {
    case common, rare, legendary

    var label: String {
        switch self {
        case .common: return "Common"
        case .rare: return "Rare"
        case .legendary: return "Legendary"
        }
    }
}

struct Achievement: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let era: String
    let symbol: String
    let isUnlocked: Bool
    let rarity: AchievementRarity
}

struct UserProfile: Identifiable {
    let id: UUID
    let name: String
    let level: String
    let levelNumber: Int
    let xp: Int
    let xpToNextLevel: Int
    let journeysCompleted: Int
    let badgesCollected: Int
    let kilometersTraced: Int
    let totem: String

    var xpProgress: Double {
        Double(xp) / Double(xpToNextLevel)
    }
}
