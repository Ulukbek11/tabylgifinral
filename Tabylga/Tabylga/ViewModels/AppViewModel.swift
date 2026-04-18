import Foundation
import SwiftUI
import Observation

enum TabylgaAPIConfiguration {
    // Replace this with the deployed Vercel URL, or provide TABYLGA_API_BASE_URL via Info.plist/scheme env.
    static let placeholderBaseURL = "https://your-project-name.vercel.app"

    static var baseURL: URL? {
        let configuredValue =
            (Bundle.main.object(forInfoDictionaryKey: "TABYLGA_API_BASE_URL") as? String) ??
            ProcessInfo.processInfo.environment["TABYLGA_API_BASE_URL"] ??
            placeholderBaseURL

        let trimmed = configuredValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            trimmed.hasPrefix("http"),
            !trimmed.contains("your-project-name"),
            let url = URL(string: trimmed)
        else {
            return nil
        }
        return url
    }
}

enum TabylgaAPIError: LocalizedError {
    case notConfigured
    case invalidResponse
    case requestFailed(Int)

    var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "TABYLGA_API_BASE_URL is not configured."
        case .invalidResponse:
            return "The backend response was invalid."
        case .requestFailed(let statusCode):
            return "The backend request failed with status \(statusCode)."
        }
    }
}

struct TabylgaAPIClient {
    static let shared = TabylgaAPIClient()

    private let baseURL: URL?

    init(baseURL: URL? = TabylgaAPIConfiguration.baseURL) {
        self.baseURL = baseURL
    }

    var isConfigured: Bool {
        baseURL != nil
    }

    func fetchCurrentMonth() async throws -> APINomadicCalendarMonth {
        try await request(path: "/calendar/current")
    }

    func fetchRoutes() async throws -> [APIRoute] {
        try await request(path: "/routes")
    }

    func fetchLocations() async throws -> [APILocation] {
        try await request(path: "/locations/search")
    }

    func fetchProfile() async throws -> APIUserProfile {
        try await request(path: "/profile/me")
    }

    func fetchAchievements() async throws -> [APIAchievement] {
        try await request(path: "/profile/achievements")
    }

    func checkIn(locationId: UUID, lat: Double, lng: Double) async throws -> APICheckInResponse {
        let body: [String: Any] = [
            "latitude": lat,
            "longitude": lng
        ]
        let data = try JSONSerialization.data(withJSONObject: body)
        return try await request(path: "/locations/\(locationId.uuidString.lowercased())/check-in", method: "POST", body: data)
    }

    private func request<T: Decodable>(path: String, method: String = "GET", body: Data? = nil) async throws -> T {
        guard let url = makeURL(path: path) else {
            throw TabylgaAPIError.notConfigured
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TabylgaAPIError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw TabylgaAPIError.requestFailed(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys // Backend uses CamelModel for camelCase
        return try decoder.decode(T.self, from: data)
    }

    private func makeURL(path: String) -> URL? {
        guard let baseURL else { return nil }
        let trimmedPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return baseURL.appendingPathComponent(trimmedPath)
    }
}

struct APINomadicCalendarMonth: Decodable {
    let id: UUID
    let kyrgyzName: String
    let gregorianEquivalent: String
    let traditionalMeaning: String
    let celestialEvent: String
    let seasonalActivity: String
    let glyph: String
}

struct APICoordinate: Decodable {
    let lat: Double
    let lng: Double
}

struct APIBadge: Decodable {
    let name: String
    let symbol: String
}

struct APILocation: Decodable {
    let id: UUID
    let name: String
    let nameMeaning: String
    let shortSummary: String
    let culturalLegend: String
    let heritageEra: String
    let coordinate: APICoordinate
    let badge: APIBadge
    let healingProperties: [String]
}

struct APIRoute: Decodable {
    let id: UUID
    let title: String
    let subtitle: String
    let region: String
    let distanceKm: Double
    let durationLabel: String
    let tags: [String]
    let heroSymbol: String
    let legend: String
    let locations: [APILocation]
}

struct APIProfileStats: Decodable {
    let xp: Int
    let xpToNext: Int
    let kilometers: Int
}

struct APIUserProfile: Decodable {
    let id: UUID
    let name: String
    let levelLabel: String
    let levelNumber: Int
    let stats: APIProfileStats
    let totem: String
    let journeysCompleted: Int
    let badgesCollected: Int
}

struct APIAchievement: Decodable {
    let id: UUID
    let title: String
    let subtitle: String
    let era: String
    let symbol: String
    let rarity: String
    let isUnlocked: Bool
}

struct APICheckInResponse: Decodable {
    let status: String
    let badgeName: String
    let xpAwarded: Int
    let distanceMeters: Double
    let profile: APIUserProfile
    let achievementUnlocked: APIAchievement?
}

@Observable
@MainActor
class AppViewModel {
    enum AppState {
        case splash
        case languageSelection
        case onboardingSteps
        case main
    }

    enum Language: String, CaseIterable, Identifiable {
        case english = "English"
        case russian = "Русский"
        case kyrgyz = "Кыргызча"
        var id: String { rawValue }
    }

    enum OnboardingStep {
        case transport
        case duration
    }

    var appState: AppState = .splash
    var currentStep: OnboardingStep = .transport
    var selectedLanguage: Language = .english
    var selectedTransport: TransportMode = .auto
    var selectedDuration: RouteDuration = .full
    var selectedTabIndex: Int = 0

    var loc: AppStrings {
        Localization.strings(for: selectedLanguage)
    }

    init() {
        Task { await bootSequence() }
    }

    private func bootSequence() async {
        try? await Task.sleep(nanoseconds: 1_800_000_000)
        self.appState = .languageSelection
    }

    func selectLanguage(_ language: Language) {
        self.selectedLanguage = language
        withAnimation {
            self.appState = .onboardingSteps
            self.currentStep = .transport
        }
    }

    func nextStep() {
        withAnimation {
            switch currentStep {
            case .transport:
                currentStep = .duration
            case .duration:
                appState = .main
            }
        }
    }

    func skipOnboarding() {
        withAnimation {
            switch appState {
            case .languageSelection:
                appState = .onboardingSteps
                currentStep = .transport
            case .onboardingSteps:
                nextStep()
            default:
                appState = .main
            }
        }
    }

    func completeOnboarding() {
        withAnimation {
            self.appState = .main
        }
    }

    func openRouteTab() {
        selectedTabIndex = 1
    }
}
