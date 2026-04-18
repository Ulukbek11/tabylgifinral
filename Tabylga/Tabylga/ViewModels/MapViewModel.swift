import Foundation
import SwiftUI
import MapKit
import CoreLocation
import Observation

@Observable
@MainActor
class MapViewModel {
    var route: Route
    var cameraPosition: MapCameraPosition
    var selectedLocation: LocationPoint?
    var isSheetPresented: Bool = false
    var userCoordinate: CLLocationCoordinate2D
    var searchText: String = ""
    var showRouteOverlay: Bool = false
    var transportType: MKDirectionsTransportType = .automobile
    var showAddPlaceSheet: Bool = false
    var isShowingNearestBanner: Bool = false

    init(route: Route? = nil) {
        let finalRoute = route ?? MockData.issykKulRoute
        self.route = finalRoute
        self.userCoordinate = CLLocationCoordinate2D(latitude: 42.50, longitude: 76.50)
        let region = MKCoordinateRegion(
            center: finalRoute.centerCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        )
        self.cameraPosition = .region(region)
    }

    func select(_ location: LocationPoint) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            selectedLocation = location
            showRouteOverlay = false // Reset overlay if switching points
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            )
        }
    }

    func dismissSheet() {
        isSheetPresented = false
    }

    func clearSearch() {
        searchText = ""
        selectedLocation = nil
        showRouteOverlay = false
        isShowingNearestBanner = false
    }

    func startRoute() {
        withAnimation(.spring()) {
            showRouteOverlay = true
        }
    }

    func cancelRoute() {
        withAnimation(.spring()) {
            showRouteOverlay = false
            selectedLocation = nil
            isShowingNearestBanner = false
        }
    }

    func selectNearest() {
        guard !route.locations.isEmpty else { return }
        
        let nearest = route.locations.min { loc1, loc2 in
            haversine(userCoordinate, loc1.coordinate) < haversine(userCoordinate, loc2.coordinate)
        }
        
        if let nearest {
            select(nearest)
            startRoute()
            withAnimation {
                isShowingNearestBanner = true
            }
        }
    }

    /// Great-circle distance between the user's current mock position and the selected location.
    var distanceToSelected: Double {
        guard let loc = selectedLocation else { return 0 }
        return haversine(userCoordinate, loc.coordinate)
    }

    var selectedLocationName: String {
        selectedLocation?.name ?? "—"
    }

    var distanceToNext: Double {
        guard let next = route.locations.first else { return 0 }
        return haversine(userCoordinate, next.coordinate)
    }

    var nextLocationName: String {
        route.locations.first?.name ?? "—"
    }

    private func haversine(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> Double {
        let earthRadius = 6371.0
        let dLat = (b.latitude - a.latitude) * .pi / 180
        let dLon = (b.longitude - a.longitude) * .pi / 180
        let lat1 = a.latitude * .pi / 180
        let lat2 = b.latitude * .pi / 180
        let h = sin(dLat/2) * sin(dLat/2) +
                sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2)
        return 2 * earthRadius * asin(sqrt(h))
    }
}
