import Foundation
import CoreLocation

struct LocationPoint: Identifiable, Hashable {
    let id: UUID
    let name: String
    let nameMeaning: String
    let shortSummary: String
    let culturalLegend: String
    let heritageEra: String
    let coordinate: CLLocationCoordinate2D
    let badgeName: String
    let badgeSymbol: String
    let healingProperties: [String]

    static func == (lhs: LocationPoint, rhs: LocationPoint) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
