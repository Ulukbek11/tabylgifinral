import SwiftUI

struct ProfileGamificationView: View {
    @State private var viewModel = ProfileViewModel()

    private let gridColumns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        ZStack {
            EthnoOrnamentBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    profileHeader
                    xpProgress
                    statsRow
                    legendaryBadgeHero
                    achievementsGrid
                        .padding(.bottom, 120)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppTheme.obsidianElevated)
                    .frame(width: 74, height: 74)
                    .overlay(
                        Circle().strokeBorder(AppTheme.neonEmber.opacity(0.7), lineWidth: 1.5)
                    )
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppTheme.goldGradient)
            }
            .addNeonGlow(color: AppTheme.neonEmber, radius: 16, intensity: 0.9)

            VStack(alignment: .leading, spacing: 4) {
                Text("LVL \(viewModel.profile.levelNumber) · TOTEM: \(viewModel.profile.totem.uppercased())")
                    .font(.system(size: 10, weight: .bold))
                    .kerning(2)
                    .foregroundStyle(AppTheme.heritageGold)
                Text(viewModel.profile.name)
                    .font(.system(size: 26, weight: .heavy, design: .serif))
                    .foregroundStyle(AppTheme.textPrimary)
                Text(viewModel.profile.level)
                    .font(.system(size: 13, weight: .medium, design: .serif))
                    .italic()
                    .foregroundStyle(AppTheme.neonEmber)
            }
            Spacer()

            Button {} label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.textSecondary)
                    .frame(width: 40, height: 40)
                    .glassCard(cornerRadius: 12)
            }
        }
    }

    private var xpProgress: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("ASCENT TO LVL \(viewModel.profile.levelNumber + 1)")
                    .font(.system(size: 10, weight: .bold))
                    .kerning(3)
                    .foregroundStyle(AppTheme.neonEmber)
                Spacer()
                Text("\(viewModel.profile.xp) / \(viewModel.profile.xpToNextLevel) XP")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppTheme.textSecondary)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.08))
                    Capsule()
                        .fill(AppTheme.emberGradient)
                        .frame(width: geo.size.width * viewModel.profile.xpProgress)
                        .addNeonGlow(color: AppTheme.neonEmber, radius: 10, intensity: 0.8)
                }
            }
            .frame(height: 10)
        }
        .padding(16)
        .glassCard(cornerRadius: 18)
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            StatTile(value: "\(viewModel.profile.journeysCompleted)", label: "Journeys", icon: "map.fill", tint: AppTheme.neonEmber)
            StatTile(value: "\(viewModel.profile.badgesCollected)", label: "Badges", icon: "rosette", tint: AppTheme.heritageGold)
            StatTile(value: "\(viewModel.profile.kilometersTraced)", label: "Km traced", icon: "figure.walk", tint: AppTheme.neonEmber)
        }
    }

    private var legendaryBadgeHero: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(AppTheme.heritageGold)
                    .frame(width: 18, height: 2)
                    .addNeonGlow(color: AppTheme.heritageGold, radius: 6, intensity: 0.6)
                Text("LEGENDARY SHOWCASE")
                    .font(.caption)
                    .kerning(3)
                    .foregroundStyle(AppTheme.heritageGold)
            }

            VStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 60, style: .continuous)
                        .stroke(AppTheme.heritageGold.opacity(0.25), lineWidth: 1)
                        .frame(width: 180, height: 180)

                    RoundedRectangle(cornerRadius: 48, style: .continuous)
                        .stroke(AppTheme.neonEmber.opacity(0.35), lineWidth: 1)
                        .frame(width: 140, height: 140)

                    ZStack {
                        RoundedRectangle(cornerRadius: 36, style: .continuous)
                            .fill(AppTheme.obsidianElevated)
                            .frame(width: 112, height: 112)
                            .overlay(
                                RoundedRectangle(cornerRadius: 36, style: .continuous)
                                    .strokeBorder(AppTheme.heritageGold, lineWidth: 1.5)
                            )
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 54, weight: .black))
                            .foregroundStyle(AppTheme.goldGradient)
                            .addNeonGlow(color: AppTheme.heritageGold, radius: 18, intensity: 1.0)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 14)

                VStack(spacing: 6) {
                    Text("BRONZE AGE · SAIMALUU-TASH")
                        .font(.system(size: 10, weight: .black))
                        .kerning(3)
                        .foregroundStyle(AppTheme.neonEmber)
                    Text("Sun-Chariot")
                        .font(.system(size: 28, weight: .black, design: .serif))
                        .foregroundStyle(AppTheme.goldGradient)
                    Text("The solar disk drawn by yoked oxen — the oldest wheel in the sky, etched at 3,000 m by an unknown Bronze Age hand.")
                        .font(.caption)
                        .foregroundStyle(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 18)

                HStack(spacing: 24) {
                    BadgeStat(label: "Rarity", value: "Legendary", tint: AppTheme.neonEmber)
                    Rectangle().fill(AppTheme.glassStroke).frame(width: 1, height: 26)
                    BadgeStat(label: "Era", value: "2000 BCE", tint: AppTheme.heritageGold)
                    Rectangle().fill(AppTheme.glassStroke).frame(width: 1, height: 26)
                    BadgeStat(label: "Holders", value: "1.2k", tint: AppTheme.textSecondary)
                }
                .padding(.bottom, 18)
            }
            .frame(maxWidth: .infinity)
            .deepGlass(cornerRadius: 28)
            .softGlow(color: AppTheme.heritageGold.opacity(0.35), radius: 18)
        }
    }

    private var achievementsGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 10) {
                    Rectangle()
                        .fill(AppTheme.neonEmber)
                        .frame(width: 18, height: 2)
                    Text("ACHIEVEMENTS")
                        .font(.caption)
                        .kerning(3)
                        .foregroundStyle(AppTheme.neonEmber)
                }
                Spacer()
                Text("\(viewModel.unlockedCount)/\(viewModel.totalCount)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.textSecondary)
            }

            LazyVGrid(columns: gridColumns, spacing: 14) {
                ForEach(viewModel.achievements) { achievement in
                    AchievementTile(achievement: achievement)
                }
            }
        }
    }
}

private struct StatTile: View {
    let value: String
    let label: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(tint)
            Text(value)
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .foregroundStyle(AppTheme.textPrimary)
            Text(label.uppercased())
                .font(.system(size: 9, weight: .bold))
                .kerning(2)
                .foregroundStyle(AppTheme.textTertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .glassCard(cornerRadius: 16)
    }
}

private struct BadgeStat: View {
    let label: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(label.uppercased())
                .font(.system(size: 8, weight: .bold))
                .kerning(1.5)
                .foregroundStyle(AppTheme.textTertiary)
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(tint)
        }
    }
}

private struct AchievementTile: View {
    let achievement: Achievement

    private var tint: Color {
        switch achievement.rarity {
        case .legendary: return AppTheme.heritageGold
        case .rare: return AppTheme.neonEmber
        case .common: return AppTheme.textSecondary
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(AppTheme.obsidianElevated)
                    .frame(width: 62, height: 62)
                    .overlay(
                        Circle()
                            .strokeBorder(
                                achievement.isUnlocked ? tint : Color.white.opacity(0.06),
                                lineWidth: 1.2
                            )
                    )
                Image(systemName: achievement.symbol)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(
                        achievement.isUnlocked ? tint : AppTheme.textTertiary
                    )
                if !achievement.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(AppTheme.textTertiary)
                        .padding(4)
                        .background(Circle().fill(AppTheme.obsidian))
                        .offset(x: 20, y: 20)
                }
            }
            .addNeonGlow(
                color: achievement.isUnlocked ? tint : .clear,
                radius: achievement.rarity == .legendary ? 14 : 10,
                intensity: achievement.isUnlocked ? 0.7 : 0
            )

            Text(achievement.title)
                .font(.system(size: 10, weight: .bold, design: .serif))
                .foregroundStyle(achievement.isUnlocked ? AppTheme.textPrimary : AppTheme.textTertiary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text(achievement.rarity.label.uppercased())
                .font(.system(size: 8, weight: .black))
                .kerning(1.2)
                .foregroundStyle(tint.opacity(achievement.isUnlocked ? 1.0 : 0.5))
        }
        .frame(maxWidth: .infinity, minHeight: 130)
        .padding(10)
        .glassCard(cornerRadius: 16)
    }
}

#Preview {
    ProfileGamificationView()
}
