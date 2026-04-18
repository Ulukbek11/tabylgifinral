import SwiftUI

enum AppTheme {
    static let obsidian = Color(red: 0.02, green: 0.02, blue: 0.02)
    static let obsidianElevated = Color(red: 0.06, green: 0.06, blue: 0.07)
    static let neonEmber = Color(red: 1.0, green: 0.27, blue: 0.0)
    static let heritageGold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let steppeDust = Color(red: 0.85, green: 0.75, blue: 0.55)
    static let glassStroke = Color.white.opacity(0.12)
    static let glassTint = Color.white.opacity(0.04)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.68)
    static let textTertiary = Color.white.opacity(0.42)

    static let obsidianGradient = LinearGradient(
        colors: [
            Color(red: 0.02, green: 0.02, blue: 0.02),
            Color(red: 0.08, green: 0.05, blue: 0.04),
            Color(red: 0.03, green: 0.02, blue: 0.02)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let emberGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.40, blue: 0.10),
            Color(red: 1.0, green: 0.18, blue: 0.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let goldGradient = LinearGradient(
        colors: [
            Color(red: 1.0, green: 0.90, blue: 0.35),
            Color(red: 0.90, green: 0.70, blue: 0.05)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
