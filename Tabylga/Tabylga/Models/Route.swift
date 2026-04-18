import Foundation
import CoreLocation

enum TransportMode: String, Codable, CaseIterable, Identifiable {
    case walk = "Foot"
    case bicycle = "Bicycle"
    case auto = "Car"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .walk: return "figure.walk"
        case .bicycle: return "bicycle"
        case .auto: return "car.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .walk: return "Trace the steppe on foot"
        case .bicycle: return "Pedal through the mountain wind"
        case .auto: return "Ride the silk road modernized"
        }
    }
}

enum RouteDuration: String, Codable, CaseIterable, Identifiable {
    case tiny = "1-2 Hours"
    case short = "Half Day"
    case full = "Full Day"
    case other = "Other"

    var id: String { rawValue }

    var hours: String {
        switch self {
        case .tiny: return "1-2 hrs"
        case .short: return "3-4 hrs"
        case .full: return "8-10 hrs"
        case .other: return "Custom pace"
        }
    }
}

struct Route: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let region: String
    let distanceKm: Double
    let durationLabel: String
    let tags: [String]
    let heroSymbol: String
    let legend: String
    let locations: [LocationPoint]

    var centerCoordinate: CLLocationCoordinate2D {
        guard !locations.isEmpty else {
            return CLLocationCoordinate2D(latitude: 42.87, longitude: 74.59)
        }
        let avgLat = locations.map(\.coordinate.latitude).reduce(0, +) / Double(locations.count)
        let avgLon = locations.map(\.coordinate.longitude).reduce(0, +) / Double(locations.count)
        return CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon)
    }

    static func == (lhs: Route, rhs: Route) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
