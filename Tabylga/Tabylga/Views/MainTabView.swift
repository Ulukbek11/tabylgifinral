import SwiftUI

struct MainTabView: View {
    @Environment(AppViewModel.self) var appViewModel: AppViewModel

    var body: some View {
        @Bindable var appViewModel = appViewModel
        ZStack(alignment: .bottom) {
            Group {
                switch appViewModel.selectedTabIndex {
                case 0: HomeFeedView()
                case 1: MapNavigationView()
                case 2: ProfileGamificationView()
                default: HomeFeedView()
                }
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.25), value: appViewModel.selectedTabIndex)

            GlassTabBar(selectedIndex: $appViewModel.selectedTabIndex)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct GlassTabBar: View {
    @Binding var selectedIndex: Int

    private let items: [(icon: String, label: String)] = [
        ("house.fill", "Home"),
        ("map.fill", "Trip"),
        ("person.fill", "Totem")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                TabButton(
                    icon: item.icon,
                    label: item.label,
                    isSelected: selectedIndex == index
                ) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        selectedIndex = index
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .deepGlass(cornerRadius: 28)
        .softGlow(color: AppTheme.neonEmber.opacity(0.25), radius: 16)
    }
}

private struct TabButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(AppTheme.neonEmber.opacity(0.15))
                            .frame(width: 54, height: 32)
                            .overlay(
                                Capsule().strokeBorder(AppTheme.neonEmber.opacity(0.6), lineWidth: 1)
                            )
                            .addNeonGlow(color: AppTheme.neonEmber, radius: 10, intensity: 0.7)
                    }
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(isSelected ? AppTheme.neonEmber : AppTheme.textSecondary)
                }
                .frame(height: 34)

                Text(label.uppercased())
                    .font(.system(size: 9, weight: .black))
                    .kerning(1.5)
                    .foregroundStyle(isSelected ? AppTheme.neonEmber : AppTheme.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
        .environment(AppViewModel())
}
