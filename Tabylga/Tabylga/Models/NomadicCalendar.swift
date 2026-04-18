import Foundation

struct NomadicCalendarMonth: Identifiable, Hashable {
    let id: UUID
    let kyrgyzName: String
    let gregorianEquivalent: String
    let traditionalMeaning: String
    let celestialEvent: String
    let seasonalActivity: String
    let glyph: String
}
