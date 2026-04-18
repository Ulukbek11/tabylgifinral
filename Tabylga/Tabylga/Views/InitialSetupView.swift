import SwiftUI

struct InitialSetupView: View {
    @Environment(AppViewModel.self) var appViewModel: AppViewModel
    @State private var animateIn: Bool = false

    var body: some View {
        ZStack {
            EthnoOrnamentBackground()

            VStack(spacing: 0) {
                // Skip Button (except for splash)
                HStack {
                    Spacer()
                    Button(appViewModel.loc.skip) {
                        appViewModel.skipOnboarding()
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(AppTheme.heritageGold)
                    .padding(24)
                }
                
                Group {
                    switch appViewModel.appState {
                    case .languageSelection:
                        languageStep
                    case .onboardingSteps:
                        if appViewModel.currentStep == .transport {
                            transportStep
                        } else {
                            durationStep
                        }
                    default:
                        EmptyView()
                    }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                      removal: .move(edge: .leading).combined(with: .opacity)))
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) { animateIn = true }
        }
    }

    private var languageStep: some View {
        VStack(alignment: .leading, spacing: 32) {
            header(title: appViewModel.loc.saalamTitle, 
                   subtitle: appViewModel.loc.saalamSubtitle)
            
            VStack(spacing: 16) {
                ForEach(AppViewModel.Language.allCases) { lang in
                    Button {
                        appViewModel.selectLanguage(lang)
                    } label: {
                        HStack {
                            Text(lang.rawValue)
                                .font(.system(size: 20, weight: .bold, design: .serif))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                        }
                        .foregroundStyle(AppTheme.textPrimary)
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .glassCard(cornerRadius: 22)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(24)
    }

    private var transportStep: some View {
        VStack(alignment: .leading, spacing: 32) {
            header(title: appViewModel.loc.transportTitle, 
                   subtitle: appViewModel.loc.transportSubtitle)
            
            VStack(spacing: 16) {
                ForEach(TransportMode.allCases) { mode in
                    TransportCard(
                        mode: mode,
                        isSelected: appViewModel.selectedTransport == mode,
                        loc: appViewModel.loc
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            appViewModel.selectedTransport = mode
                        }
                    }
                }
            }
            
            Spacer()
            
            nextButton
        }
        .padding(24)
    }

    private var durationStep: some View {
        VStack(alignment: .leading, spacing: 32) {
            header(title: appViewModel.loc.durationTitle, 
                   subtitle: appViewModel.loc.durationSubtitle)
            
            VStack(spacing: 12) {
                ForEach(RouteDuration.allCases) { duration in
                    DurationRow(
                        duration: duration,
                        isSelected: appViewModel.selectedDuration == duration
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            appViewModel.selectedDuration = duration
                        }
                    }
                }
            }
            
            Spacer()
            
            nextButton
        }
        .padding(24)
    }

    private func header(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Circle()
                    .fill(AppTheme.neonEmber)
                    .frame(width: 8, height: 8)
                    .addNeonGlow(color: AppTheme.neonEmber, radius: 8)
                Text("\(appViewModel.loc.appName) · NOMAD'S PATH")
                    .font(.caption)
                    .kerning(3)
                    .foregroundStyle(AppTheme.heritageGold)
            }

            Text(title)
                .font(.system(size: 36, weight: .heavy, design: .serif))
                .foregroundStyle(AppTheme.textPrimary)
                .lineSpacing(4)

            Text(subtitle)
                .font(.callout)
                .foregroundStyle(AppTheme.textSecondary)
                .lineSpacing(3)
                .padding(.top, 4)
        }
    }

    private var nextButton: some View {
        Button {
            appViewModel.nextStep()
        } label: {
            HStack(spacing: 12) {
                Text(appViewModel.loc.continueButton)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .kerning(1)
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundStyle(Color.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(AppTheme.emberGradient)
            )
        }
        .addNeonGlow(color: AppTheme.neonEmber, radius: 22, intensity: 1.0)
    }
}

private struct TransportCard: View {
    let mode: TransportMode
    let isSelected: Bool
    let loc: AppStrings
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: mode.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(isSelected ? AppTheme.neonEmber : AppTheme.textPrimary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(localizedName)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundStyle(AppTheme.textPrimary)
                    Text(mode.subtitle)
                        .font(.caption)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppTheme.neonEmber)
                        .addNeonGlow(color: AppTheme.neonEmber, radius: 8)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassCard(cornerRadius: 20)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(isSelected ? AppTheme.neonEmber : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var localizedName: String {
        switch mode {
        case .walk: return loc.walk
        case .bicycle: return loc.cycle
        case .auto: return loc.car
        }
    }
}

private struct DurationRow: View {
    let duration: RouteDuration
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(duration.rawValue)
                    .font(.system(size: 18, weight: .semibold, design: .serif))
                    .foregroundStyle(AppTheme.textPrimary)
                Spacer()
                Text(duration.hours)
                    .font(.caption)
                    .foregroundStyle(AppTheme.textSecondary)
                
                if isSelected {
                    Circle()
                        .fill(AppTheme.neonEmber)
                        .frame(width: 8, height: 8)
                        .addNeonGlow(color: AppTheme.neonEmber, radius: 6)
                }
            }
            .padding(18)
            .glassCard(cornerRadius: 16)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isSelected ? AppTheme.neonEmber : Color.clear, lineWidth: 1.2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    InitialSetupView()
        .environment(AppViewModel())
}
