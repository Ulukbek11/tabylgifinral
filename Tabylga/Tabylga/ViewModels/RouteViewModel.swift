import Foundation
import SwiftUI
import CoreLocation
import Observation

@Observable
@MainActor
class RouteViewModel {
    private let apiClient: TabylgaAPIClient
    var routes: [Route]
    var featuredRoute: Route
    var calendarMonth: NomadicCalendarMonth

    init(apiClient: TabylgaAPIClient = .shared) {
        self.apiClient = apiClient
        self.routes = MockData.routes
        self.featuredRoute = MockData.issykKulRoute
        self.calendarMonth = MockData.currentMonth

        Task { await refreshFromAPIIfConfigured() }
    }

    func select(_ route: Route) {
        self.featuredRoute = route
    }

    func refreshFromAPIIfConfigured() async {
        guard apiClient.isConfigured else { return }

        do {
            async let routesResponse = apiClient.fetchRoutes()
            async let monthResponse = apiClient.fetchCurrentMonth()

            let routePayload = try await routesResponse
            let monthPayload = try await monthResponse
            let fetchedRoutes = routePayload.map { $0.toModel() }
            let fetchedMonth = monthPayload.toModel()

            if !fetchedRoutes.isEmpty {
                self.routes = fetchedRoutes
                self.featuredRoute = fetchedRoutes[0]
            }
            self.calendarMonth = fetchedMonth
        } catch {
            // Preserve mock data as a silent fallback when the remote backend is unavailable.
        }
    }
}

private extension APINomadicCalendarMonth {
    func toModel() -> NomadicCalendarMonth {
        NomadicCalendarMonth(
            id: id,
            kyrgyzName: kyrgyzName,
            gregorianEquivalent: gregorianEquivalent,
            traditionalMeaning: traditionalMeaning,
            celestialEvent: celestialEvent,
            seasonalActivity: seasonalActivity,
            glyph: glyph
        )
    }
}

private extension APILocation {
    func toModel() -> LocationPoint {
        LocationPoint(
            id: id,
            name: name,
            nameMeaning: nameMeaning,
            shortSummary: shortSummary,
            culturalLegend: culturalLegend,
            heritageEra: heritageEra,
            coordinate: CLLocationCoordinate2D(
                latitude: coordinate.lat,
                longitude: coordinate.lng
            ),
            badgeName: badge.name,
            badgeSymbol: badge.symbol,
            healingProperties: healingProperties
        )
    }
}

private extension APIRoute {
    func toModel() -> Route {
        Route(
            id: id,
            title: title,
            subtitle: subtitle,
            region: region,
            distanceKm: distanceKm,
            durationLabel: durationLabel,
            tags: tags,
            heroSymbol: heroSymbol,
            legend: legend,
            locations: locations.map { $0.toModel() }
        )
    }
}
