import SwiftUI

@main
struct TabylgaNomadsPathApp: App {
    @State private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appViewModel)
                .preferredColorScheme(.dark)
        }
    }
}

struct RootView: View {
    @Environment(AppViewModel.self) var appViewModel: AppViewModel

    var body: some View {
        ZStack {
            switch appViewModel.appState {
            case .splash:
                SplashView()
                    .transition(.opacity)
            case .languageSelection, .onboardingSteps:
                InitialSetupView()
                    .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .top).combined(with: .opacity)))
            case .main:
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.6), value: appViewModel.appState)
    }
}
