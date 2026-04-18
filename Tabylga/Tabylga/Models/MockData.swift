import Foundation
import CoreLocation

enum MockData {

    // MARK: - Nomadic Calendar
    static let currentMonth = NomadicCalendarMonth(
        id: UUID(uuidString: "86753090-0000-0000-0000-000000000001")!,
        kyrgyzName: "Chyn Kuran",
        gregorianEquivalent: "April",
        traditionalMeaning: "The time of new life and the preparation of kumys — when the steppe exhales, mares foal, and the first fermented milk is poured for the ancestors.",
        celestialEvent: "Conjunction of the Moon with the Pleiades (Urker) star cluster — the nomad's astronomical anchor for the new cycle.",
        seasonalActivity: "Kumys preparation · Herd migration to jailoo · Renewal rites at sacred springs",
        glyph: "moon.stars.fill"
    )

    static let calendarYear: [NomadicCalendarMonth] = [
        NomadicCalendarMonth(
            id: UUID(uuidString: "86753090-0000-0000-0000-000000000000")!,
            kyrgyzName: "Jalgan Kuran",
            gregorianEquivalent: "March",
            traditionalMeaning: "The 'False' Month of the Roe Deer. Nature begins to stir, but winter's breath still lingers in the valleys.",
            celestialEvent: "Spring Equinox (Nooruz). The sun crosses the celestial equator.",
            seasonalActivity: "Preparation for the new cycle · First awakening of the soil.",
            glyph: "leaf.arrow.triangle.circlepath"
        ),
        currentMonth,
        NomadicCalendarMonth(
            id: UUID(uuidString: "86753090-0000-0000-0000-000000000002")!,
            kyrgyzName: "Bugu",
            gregorianEquivalent: "May",
            traditionalMeaning: "Month of the Deer. The sacred totem of the Bugu tribe. The high pastures turn emerald.",
            celestialEvent: "Urker (Pleiades) rises before dawn — time of ascent to summer pastures.",
            seasonalActivity: "Ascent to jailoo · Eagle training begins.",
            glyph: "sparkle"
        ),
        NomadicCalendarMonth(
            id: UUID(uuidString: "86753090-0000-0000-0000-000000000003")!,
            kyrgyzName: "Kulja",
            gregorianEquivalent: "June",
            traditionalMeaning: "Month of the Mountain Sheep (Argali). The time of peak summer energy.",
            celestialEvent: "Summer Solstice. The longest day of the nomadic year.",
            seasonalActivity: "Sheep shearing · High-altitude festivities.",
            glyph: "sun.max.fill"
        ),
        NomadicCalendarMonth(
            id: UUID(uuidString: "86753090-0000-0000-0000-000000000004")!,
            kyrgyzName: "Tekey",
            gregorianEquivalent: "July",
            traditionalMeaning: "Month of the Ibex. The herds thrive in the highest, cleanest air.",
            celestialEvent: "Full Moon of the Great Heat. Sirius (Sumbula) becomes visible.",
            seasonalActivity: "Herding in the high peaks · Gathering mountain herbs.",
            glyph: "mountain.2.fill"
        ),
        NomadicCalendarMonth(
            id: UUID(uuidString: "86753090-0000-0000-0000-000000000005")!,
            kyrgyzName: "Bash-Oona",
            gregorianEquivalent: "August",
            traditionalMeaning: "The turning of the heat. The first signs of autumn's approach.",
            celestialEvent: "Meteor showers (Perseids) visible over the dark jailoo sky.",
            seasonalActivity: "Harvesting the first grains · Preparing for descent.",
            glyph: "leaf.fill"
        ),
        NomadicCalendarMonth(
            id: UUID(uuidString: "86753090-0000-0000-0000-000000000006")!,
            kyrgyzName: "Ayak-Oona",
            gregorianEquivalent: "September",
            traditionalMeaning: "The final harvest month. The earth prepares for rest.",
            celestialEvent: "Autumn Equinox. Day and night are equal once more.",
            seasonalActivity: "Descent from the jailoo · Final kumys festivals.",
            glyph: "leaf.arrow.circlepath"
        ),
        NomadicCalendarMonth(
            id: UUID(uuidString: "86753090-0000-0000-0000-000000000007")!,
            kyrgyzName: "Toguzdun Ayı",
            gregorianEquivalent: "October",
            traditionalMeaning: "The month of the number nine. A sacred number for the Kyrgyz people.",
            celestialEvent: "Full Moon of the Nine Spirits.",
            seasonalActivity: "Preparing winter shelters · Storing dried meat.",
            glyph: "9.circle.fill"
        ),
        NomadicCalendarMonth(
            id: UUID(uuidString: "86753090-0000-0000-0000-000000000008")!,
            kyrgyzName: "Jetinin Ayı",
            gregorianEquivalent: "November",
            traditionalMeaning: "The month of the number seven. Marking the deepening of the cold.",
            celestialEvent: "First heavy frosts. Orion (Uch-Arkar) climbs high.",
            seasonalActivity: "Deep winter preparations · Storytelling begins.",
            glyph: "7.circle.fill"
        ),
        NomadicCalendarMonth(
            id: UUID(uuidString: "86753090-0000-0000-0000-000000000009")!,
            kyrgyzName: "Beshtin Ayı",
            gregorianEquivalent: "December",
            traditionalMeaning: "The month of the number five. The heart of the winter freeze.",
            celestialEvent: "Winter Solstice. The shortest day and longest night.",
            seasonalActivity: "Winter indoor crafts · Ancestral stories by the fire.",
            glyph: "snowflake"
        ),
        NomadicCalendarMonth(
            id: UUID(uuidString: "86753090-0000-0000-0000-000000000010")!,
            kyrgyzName: "Üchtün Ayı",
            gregorianEquivalent: "January",
            traditionalMeaning: "The month of the number three. The deepest snows blanket the steppe.",
            celestialEvent: "Deep Winter New Moon.",
            seasonalActivity: "Survival and communal resilience.",
            glyph: "cloud.snow.fill"
        ),
        NomadicCalendarMonth(
            id: UUID(uuidString: "86753090-0000-0000-0000-000000000011")!,
            kyrgyzName: "Birdin Ayı",
            gregorianEquivalent: "February",
            traditionalMeaning: "The month of the number one. The final stretch before the spring awakening.",
            celestialEvent: "End of the Great Cold (Childe).",
            seasonalActivity: "Waiting for the first signs of the lark.",
            glyph: "bird.fill"
        )
    ]

    // MARK: - Locations
    static let cholponAta = LocationPoint(
        id: UUID(uuidString: "A0E1B2C3-D4E5-F6A7-B8C9-D0E1F2A3B4C5")!,
        name: "Cholpon-Ata",
        nameMeaning: "Father of the Morning Star (Venus) — the dawn shepherd watching over the flocks.",
        shortSummary: "Iron Age petroglyph sanctuary on the north shore of Issyk-Kul.",
        culturalLegend: "An open-air stone sanctuary of the Saka-Scythian nomads. The boulders here are carved with leaping ibex, stalking snow leopards, and mounted hunters rendered in the unmistakable Saka Animal Style — a visual language that flowed from the Altai to the Black Sea. Local tradition holds that the stones sing at the rising of Venus, when the morning star — Cholpon — first touches the peaks of the Kungey Ala-Too.",
        heritageEra: "Iron Age · Saka Animal Style",
        coordinate: CLLocationCoordinate2D(latitude: 42.6486, longitude: 77.0811),
        badgeName: "Stone Memory Keeper",
        badgeSymbol: "scroll.fill",
        healingProperties: ["Vision of ancestors", "Orientation by stars"]
    )

    static let manjylyAta = LocationPoint(
        id: UUID(uuidString: "B1E2C3D4-E5F6-A7B8-C9D0-E1F2A3B4C5D6")!,
        name: "Manjyly-Ata",
        nameMeaning: "Father Manjyly — guardian of the southern shore, whose valley whispers cures.",
        shortSummary: "Sacred valley of labyrinths and healing springs on the south shore of Issyk-Kul.",
        culturalLegend: "A valley of stone labyrinths and natural springs considered among the most sacred pilgrimage sites on Issyk-Kul. The central spring — 'Bugu-Ene', the Mother Deer — is said to flow from the milk of the mythic doe who mothered the Kyrgyz tribes. Pilgrims walk the labyrinths barefoot and drink from seven distinct springs, each one known to cure a different ailment: eye, liver, kidney, heart, spine, breath, and sorrow.",
        heritageEra: "Ongoing sacred pilgrimage · Medieval Sufi syncretism",
        coordinate: CLLocationCoordinate2D(latitude: 42.1786, longitude: 77.0922),
        badgeName: "Bugu-Ene Pilgrim",
        badgeSymbol: "drop.fill",
        healingProperties: ["Eye ailments", "Liver renewal", "Clarity of intention"]
    )

    static let saimaluuTash = LocationPoint(
        id: UUID(uuidString: "C2E3D4E5-F6A7-B8C9-D0E1-F2A3B4C5D6E7")!,
        name: "Saimaluu-Tash",
        nameMeaning: "The Embroidered Stones — a mountain pass carpeted with carved boulders.",
        shortSummary: "The largest open-air petroglyph gallery in Central Asia, at 3,000 m altitude.",
        culturalLegend: "Over 10,000 petroglyphs spanning the Bronze Age to the Middle Ages. Among them: the famous 'Sun-Chariot' — a solar disk drawn by yoked oxen — rendered in Bronze Age lines that still radiate the cosmology of sky worship. The site is reachable only on horseback during the brief summer window.",
        heritageEra: "Bronze Age · UNESCO tentative list",
        coordinate: CLLocationCoordinate2D(latitude: 41.2167, longitude: 73.7500),
        badgeName: "Sun-Chariot Seeker",
        badgeSymbol: "sun.max.fill",
        healingProperties: ["Cosmic alignment", "Artisan sight"]
    )

    static let songKol = LocationPoint(
        id: UUID(uuidString: "D3E4D5E6-F7A8-B9C0-D1E2-F3A4B5C6D7E8")!,
        name: "Son-Kol",
        nameMeaning: "The Last Lake — final high-altitude pasture before the sky.",
        shortSummary: "Alpine jailoo at 3,016 m — the living summer pasture of the nomads.",
        culturalLegend: "A crescent of living yurts at 3,016 meters, where the summer jailoo has been unchanged for a millennium. Here the kumys ferments fastest, the stars read clearest, and the hawks train their young on the wind.",
        heritageEra: "Living tradition · Jailoo pastoralism",
        coordinate: CLLocationCoordinate2D(latitude: 41.8375, longitude: 75.1264),
        badgeName: "Jailoo Dweller",
        badgeSymbol: "tent.fill",
        healingProperties: ["Silence", "Altitude clarity"]
    )

    // MARK: - Routes
    static let issykKulRoute = Route(
        id: UUID(uuidString: "E4F5D6E7-F8A9-B0C1-D2E3-F4A5B6C7D8E9")!,
        title: "Mysteries of Issyk-Kul",
        subtitle: "From the Morning Star to the Mother Deer",
        region: "Issyk-Kul Oblast",
        distanceKm: 218,
        durationLabel: "Full Day",
        tags: ["Auto", "Full Day", "Sacred", "Petroglyphs"],
        heroSymbol: "water.waves",
        legend: "A circuit of the warm lake that never freezes — tracing the arc from the Iron Age stone gallery of Cholpon-Ata to the labyrinth springs of Manjyly-Ata, crossing the water where the Saka left their chariot offerings.",
        locations: [cholponAta, manjylyAta]
    )

    static let saimaluuRoute = Route(
        id: UUID(uuidString: "F5F6D7E8-F9A0-B1C2-D3E4-F5A6B7C8D9E0")!,
        title: "Embroidered Stones Ascent",
        subtitle: "Horseback pilgrimage to the Bronze Age sun",
        region: "Jalal-Abad · Ferghana Range",
        distanceKm: 64,
        durationLabel: "Multi-Day",
        tags: ["Walk", "Horse", "Multi-Day", "Bronze Age"],
        heroSymbol: "mountain.2.fill",
        legend: "A three-day ascent to Saimaluu-Tash at 3,000 meters, where 10,000 petroglyphs — including the famed Sun-Chariot — have watched the sky since the Bronze Age.",
        locations: [saimaluuTash]
    )

    static let songKolRoute = Route(
        id: UUID(uuidString: "06A7B8C9-D0E1-F2A3-B4C5-D6E7F8A9B0C1")!,
        title: "Jailoo of Son-Kol",
        subtitle: "A night among the high-altitude yurts",
        region: "Naryn Oblast",
        distanceKm: 102,
        durationLabel: "Multi-Day",
        tags: ["Auto", "Walk", "Multi-Day", "Living Tradition"],
        heroSymbol: "tent.2.fill",
        legend: "Ascend to 3,016 meters where the crescent lake cradles a circle of yurts. Drink kumys, train an eaglet's eye, and fall asleep under the same sky the Saka watched.",
        locations: [songKol]
    )

    static let routes: [Route] = [issykKulRoute, saimaluuRoute, songKolRoute]

    // MARK: - User
    static let userProfile = UserProfile(
        id: UUID(uuidString: "17B8C9D0-E1F2-A3B4-C5D6-E7F8A9B0C1D2")!,
        name: "Aybek",
        level: "Wanderer of the Steppe",
        levelNumber: 4,
        xp: 2380,
        xpToNextLevel: 3500,
        journeysCompleted: 7,
        badgesCollected: 12,
        kilometersTraced: 486,
        totem: "Bugu"
    )

    // MARK: - Achievements
    static let achievements: [Achievement] = [
        Achievement(
            id: UUID(uuidString: "28C9D0E1-F2A3-B4C5-D6E7-F8A9B0C1D2E3")!,
            title: "Sun-Chariot of Saimaluu-Tash",
            subtitle: "Witnessed the Bronze Age solar disk drawn by yoked oxen — the oldest wheel in the sky.",
            era: "Bronze Age · 2000 BCE",
            symbol: "sun.max.fill",
            isUnlocked: true,
            rarity: .legendary
        ),
        Achievement(
            id: UUID(uuidString: "39D0E1F2-A3B4-C5D6-E7F8-A9B0C1D2E3F4")!,
            title: "Saka Animal Style Scholar",
            subtitle: "Read the leaping ibex of Cholpon-Ata.",
            era: "Iron Age",
            symbol: "pawprint.fill",
            isUnlocked: true,
            rarity: .rare
        ),
        Achievement(
            id: UUID(uuidString: "40E1F2A3-B4C5-D6E7-F8A9-B0C1D2E3F4A5")!,
            title: "Bugu-Ene Pilgrim",
            subtitle: "Walked the seven springs of Manjyly-Ata.",
            era: "Living tradition",
            symbol: "drop.fill",
            isUnlocked: true,
            rarity: .rare
        ),
        Achievement(
            id: UUID(uuidString: "51F2A3B4-C5D6-E7F8-A9B0-C1D2E3F4A5B6")!,
            title: "Urker Stargazer",
            subtitle: "Tracked the Pleiades across a jailoo night.",
            era: "Celestial",
            symbol: "sparkles",
            isUnlocked: true,
            rarity: .common
        ),
        Achievement(
            id: UUID(uuidString: "62A3B4C5-D6E7-F8A9-B0C1-D2E3F4A5B6C7")!,
            title: "Kumys Initiate",
            subtitle: "Tasted fermented mare's milk in Chyn Kuran.",
            era: "Chyn Kuran",
            symbol: "cup.and.saucer.fill",
            isUnlocked: true,
            rarity: .common
        ),
        Achievement(
            id: UUID(uuidString: "73B4C5D6-E7F8-A9B0-C1D2-E3F4A5B6C7D8")!,
            title: "Eagle Hunter Apprentice",
            subtitle: "Held a trained burkut on the wrist.",
            era: "Living tradition",
            symbol: "bird.fill",
            isUnlocked: false,
            rarity: .legendary
        ),
        Achievement(
            id: UUID(uuidString: "84C5D6E7-F8A9-B0C1-D2E3-F4A5B6C7D8E9")!,
            title: "Stone Labyrinth Walker",
            subtitle: "Traced the sacred spiral barefoot.",
            era: "Medieval",
            symbol: "circle.hexagongrid.fill",
            isUnlocked: false,
            rarity: .rare
        ),
        Achievement(
            id: UUID(uuidString: "95D6E7F8-A9B0-C1D2-E3F4-A5B6C7D8E9F0")!,
            title: "Tengri Sky-Witness",
            subtitle: "Saw the sky open over Son-Kol.",
            era: "Celestial",
            symbol: "cloud.sun.fill",
            isUnlocked: false,
            rarity: .common
        )
    ]

    static var legendaryAchievement: Achievement {
        achievements.first(where: { $0.rarity == .legendary && $0.isUnlocked }) ?? achievements[0]
    }
}
