from datetime import datetime, timezone
from uuid import UUID

from geoalchemy2.elements import WKTElement
from sqlalchemy import select
from sqlalchemy.orm import Session

from .models import (
    Achievement,
    LocalizationBundle,
    LocationPoint,
    NomadicCalendarMonth,
    Route,
    UserAchievement,
    UserCheckIn,
    UserProfile,
    route_locations,
)


PROFILE_ID = UUID("0a8f2285-f74f-45d1-90d3-1e6cf5111111")

LOCATION_IDS = {
    "cholpon_ata": UUID("4c81d6d8-6f4f-4984-89d4-f0e9361f1001"),
    "manjyly_ata": UUID("4c81d6d8-6f4f-4984-89d4-f0e9361f1002"),
    "saimaluu_tash": UUID("4c81d6d8-6f4f-4984-89d4-f0e9361f1003"),
    "son_kol": UUID("4c81d6d8-6f4f-4984-89d4-f0e9361f1004"),
}

ROUTE_IDS = {
    "issyk_kul": UUID("7a8bc6cb-4cb9-4279-a8b0-55db721a2001"),
    "saimaluu": UUID("7a8bc6cb-4cb9-4279-a8b0-55db721a2002"),
    "son_kol": UUID("7a8bc6cb-4cb9-4279-a8b0-55db721a2003"),
}

ACHIEVEMENT_IDS = {
    "sun_chariot": UUID("84ecea91-cf92-4f78-90a9-bfe3132b3001"),
    "saka_scholar": UUID("84ecea91-cf92-4f78-90a9-bfe3132b3002"),
    "bugu_pilgrim": UUID("84ecea91-cf92-4f78-90a9-bfe3132b3003"),
    "urker_stargazer": UUID("84ecea91-cf92-4f78-90a9-bfe3132b3004"),
    "kumys_initiate": UUID("84ecea91-cf92-4f78-90a9-bfe3132b3005"),
    "eagle_hunter": UUID("84ecea91-cf92-4f78-90a9-bfe3132b3006"),
    "stone_labyrinth": UUID("84ecea91-cf92-4f78-90a9-bfe3132b3007"),
    "tengri_sky": UUID("84ecea91-cf92-4f78-90a9-bfe3132b3008"),
}


def point(longitude: float, latitude: float) -> WKTElement:
    return WKTElement(f"POINT({longitude} {latitude})", srid=4326)


def seed_database(session: Session) -> None:
    existing_profile = session.scalar(select(UserProfile).where(UserProfile.external_id == "me"))
    if existing_profile is not None:
        return

    locations = [
        LocationPoint(
            id=LOCATION_IDS["cholpon_ata"],
            name="Cholpon-Ata",
            region="Issyk-Kul Oblast",
            name_meaning="Father of the Morning Star (Venus) — the dawn shepherd watching over the flocks.",
            short_summary="Iron Age petroglyph sanctuary on the north shore of Issyk-Kul.",
            cultural_legend=(
                "An open-air stone sanctuary of the Saka-Scythian nomads. The boulders here are carved with "
                "leaping ibex, stalking snow leopards, and mounted hunters rendered in the Saka Animal Style."
            ),
            heritage_era="Iron Age · Saka Animal Style",
            tags=["Sacred", "Petroglyphs", "Iron Age"],
            geom=point(77.0811, 42.6486),
            badge_name="Stone Memory Keeper",
            badge_symbol="scroll.fill",
            healing_properties=["Vision of ancestors", "Orientation by stars"],
        ),
        LocationPoint(
            id=LOCATION_IDS["manjyly_ata"],
            name="Manjyly-Ata",
            region="Issyk-Kul Oblast",
            name_meaning="Father Manjyly — guardian of the southern shore, whose valley whispers cures.",
            short_summary="Sacred valley of labyrinths and healing springs on the south shore of Issyk-Kul.",
            cultural_legend=(
                "A valley of stone labyrinths and natural springs considered among the most sacred pilgrimage "
                "sites on Issyk-Kul. Pilgrims walk the labyrinths barefoot and drink from seven distinct springs."
            ),
            heritage_era="Ongoing sacred pilgrimage · Medieval Sufi syncretism",
            tags=["Sacred", "Pilgrimage", "Healing Springs"],
            geom=point(77.0922, 42.1786),
            badge_name="Bugu-Ene Pilgrim",
            badge_symbol="drop.fill",
            healing_properties=["Eye ailments", "Liver renewal", "Clarity of intention"],
        ),
        LocationPoint(
            id=LOCATION_IDS["saimaluu_tash"],
            name="Saimaluu-Tash",
            region="Jalal-Abad Oblast",
            name_meaning="The Embroidered Stones — a mountain pass carpeted with carved boulders.",
            short_summary="The largest open-air petroglyph gallery in Central Asia, high in the Ferghana Range.",
            cultural_legend=(
                "Over 10,000 petroglyphs spanning the Bronze Age to the Middle Ages. Among them is the famous "
                "Sun-Chariot — a solar disk drawn by yoked oxen and tied to sky-worship cosmology."
            ),
            heritage_era="Bronze Age · UNESCO tentative list",
            tags=["Petroglyphs", "Bronze Age", "Mountain Pass"],
            geom=point(73.75, 41.2167),
            badge_name="Sun-Chariot Seeker",
            badge_symbol="sun.max.fill",
            healing_properties=["Cosmic alignment", "Artisan sight"],
        ),
        LocationPoint(
            id=LOCATION_IDS["son_kol"],
            name="Son-Kol",
            region="Naryn Oblast",
            name_meaning="The Last Lake — final high-altitude pasture before the sky.",
            short_summary="Alpine jailoo at 3,016 meters — the living summer pasture of the nomads.",
            cultural_legend=(
                "A crescent of living yurts at 3,016 meters, where the summer jailoo has remained a pastoral "
                "heartbeat for generations. Kumys ferments quickly here, and the stars read clearly."
            ),
            heritage_era="Living tradition · Jailoo pastoralism",
            tags=["Living Tradition", "Jailoo", "High Altitude"],
            geom=point(75.1264, 41.8375),
            badge_name="Jailoo Dweller",
            badge_symbol="tent.fill",
            healing_properties=["Silence", "Altitude clarity"],
        ),
    ]
    session.add_all(locations)

    routes = [
        Route(
            id=ROUTE_IDS["issyk_kul"],
            title="Mysteries of Issyk-Kul",
            subtitle="From the Morning Star to the Mother Deer",
            region="Issyk-Kul Oblast",
            distance_km=218,
            duration_label="Full Day",
            transport_modes=["car", "bicycle", "walk"],
            tags=["Sacred", "Petroglyphs", "Lake Circuit"],
            hero_symbol="water.waves",
            legend=(
                "A circuit of the warm lake that never freezes — tracing the arc from the Iron Age stone "
                "gallery of Cholpon-Ata to the labyrinth springs of Manjyly-Ata."
            ),
        ),
        Route(
            id=ROUTE_IDS["saimaluu"],
            title="Embroidered Stones Ascent",
            subtitle="Mountain approach to the Bronze Age sun",
            region="Jalal-Abad Oblast",
            distance_km=64,
            duration_label="Multi-Day",
            transport_modes=["walk"],
            tags=["Bronze Age", "Petroglyphs", "Mountain Pass"],
            hero_symbol="mountain.2.fill",
            legend=(
                "A slow ascent toward Saimaluu-Tash, where thousands of petroglyphs hold the oldest stories "
                "of wheels, sun symbols, and herds on stone."
            ),
        ),
        Route(
            id=ROUTE_IDS["son_kol"],
            title="Jailoo of Son-Kol",
            subtitle="A high-altitude caravan under open sky",
            region="Naryn Oblast",
            distance_km=102,
            duration_label="Multi-Day",
            transport_modes=["car", "bicycle", "walk"],
            tags=["Living Tradition", "Jailoo", "Celestial"],
            hero_symbol="tent.2.fill",
            legend=(
                "Ascend to 3,016 meters where the crescent lake cradles yurts, eagle hunters, and the sky "
                "patterns the nomads still read."
            ),
        ),
    ]
    session.add_all(routes)
    session.flush()

    session.execute(
        route_locations.insert(),
        [
            {
                "route_id": ROUTE_IDS["issyk_kul"],
                "location_id": LOCATION_IDS["cholpon_ata"],
                "stop_order": 0,
            },
            {
                "route_id": ROUTE_IDS["issyk_kul"],
                "location_id": LOCATION_IDS["manjyly_ata"],
                "stop_order": 1,
            },
            {
                "route_id": ROUTE_IDS["saimaluu"],
                "location_id": LOCATION_IDS["saimaluu_tash"],
                "stop_order": 0,
            },
            {
                "route_id": ROUTE_IDS["son_kol"],
                "location_id": LOCATION_IDS["son_kol"],
                "stop_order": 0,
            },
        ],
    )

    months_data = [
        ("Jalgan Kuran", "March", "leaf.arrow.triangle.circlepath", 3, "The false month of awakening.", "Spring Equinox (Nooruz).", "Preparation for the new cycle."),
        ("Chyn Kuran", "April", "moon.stars.fill", 4, "New life rises with the foaling mares.", "Moon with Urker (Pleiades).", "Kumys preparation and renewal rites."),
        ("Bugu", "May", "sparkle", 5, "Month of the Deer and the Bugu totem.", "Urker before dawn marks ascent.", "Move to the summer pastures."),
        ("Kulja", "June", "sun.max.fill", 6, "Peak summer vitality on the steppe.", "Summer Solstice.", "Sheep shearing and high-altitude festivities."),
        ("Tekey", "July", "mountain.2.fill", 7, "The ibex month in the clean mountain air.", "Sirius appears in the night sky.", "Gather herbs and watch the high herds."),
        ("Bash-Oona", "August", "leaf.fill", 8, "Heat begins to turn toward autumn.", "Perseid meteor showers.", "Harvest first grains and prepare descent."),
        ("Ayak-Oona", "September", "leaf.arrow.circlepath", 9, "The final harvest before rest.", "Autumn Equinox.", "Descend from jailoo and close summer rites."),
        ("Toguzdun Ayı", "October", "9.circle.fill", 10, "The month of nine sacred forces.", "Full Moon of the Nine Spirits.", "Prepare winter shelters."),
        ("Jetinin Ayı", "November", "7.circle.fill", 11, "The month of seven as frost deepens.", "Orion climbs high.", "Store provisions and begin story season."),
        ("Beshtin Ayı", "December", "snowflake", 12, "The heart of winter freeze.", "Winter Solstice.", "Indoor crafts and ancestral stories."),
        ("Üchtün Ayı", "January", "cloud.snow.fill", 1, "Deep snow settles over the steppe.", "Deep Winter New Moon.", "Survival and communal resilience."),
        ("Birdin Ayı", "February", "bird.fill", 2, "The last wait before spring signs return.", "End of the Great Cold.", "Watch for the first bird and thaw."),
    ]

    session.add_all(
        [
            NomadicCalendarMonth(
                kyrgyz_name=kyrgyz_name,
                gregorian_equivalent=gregorian_equivalent,
                traditional_meaning=traditional_meaning,
                celestial_event=celestial_event,
                seasonal_activity=seasonal_activity,
                glyph=glyph,
                month_index=month_index,
            )
            for kyrgyz_name, gregorian_equivalent, glyph, month_index, traditional_meaning, celestial_event, seasonal_activity in months_data
        ]
    )

    achievements = [
        Achievement(
            id=ACHIEVEMENT_IDS["sun_chariot"],
            slug="sun-chariot-seeker",
            title="Sun-Chariot of Saimaluu-Tash",
            subtitle="Witnessed the Bronze Age solar disk drawn by yoked oxen.",
            era="Bronze Age · 2000 BCE",
            symbol="sun.max.fill",
            rarity="legendary",
            location_id=LOCATION_IDS["saimaluu_tash"],
        ),
        Achievement(
            id=ACHIEVEMENT_IDS["saka_scholar"],
            slug="saka-animal-style-scholar",
            title="Saka Animal Style Scholar",
            subtitle="Read the leaping ibex of Cholpon-Ata.",
            era="Iron Age",
            symbol="pawprint.fill",
            rarity="rare",
            location_id=LOCATION_IDS["cholpon_ata"],
        ),
        Achievement(
            id=ACHIEVEMENT_IDS["bugu_pilgrim"],
            slug="bugu-ene-pilgrim",
            title="Bugu-Ene Pilgrim",
            subtitle="Walked the seven springs of Manjyly-Ata.",
            era="Living tradition",
            symbol="drop.fill",
            rarity="rare",
            location_id=LOCATION_IDS["manjyly_ata"],
        ),
        Achievement(
            id=ACHIEVEMENT_IDS["urker_stargazer"],
            slug="urker-stargazer",
            title="Urker Stargazer",
            subtitle="Tracked the Pleiades across a jailoo night.",
            era="Celestial",
            symbol="sparkles",
            rarity="common",
        ),
        Achievement(
            id=ACHIEVEMENT_IDS["kumys_initiate"],
            slug="kumys-initiate",
            title="Kumys Initiate",
            subtitle="Tasted fermented mare's milk in Chyn Kuran.",
            era="Chyn Kuran",
            symbol="cup.and.saucer.fill",
            rarity="common",
        ),
        Achievement(
            id=ACHIEVEMENT_IDS["eagle_hunter"],
            slug="eagle-hunter-apprentice",
            title="Eagle Hunter Apprentice",
            subtitle="Held a trained burkut on the wrist.",
            era="Living tradition",
            symbol="bird.fill",
            rarity="legendary",
        ),
        Achievement(
            id=ACHIEVEMENT_IDS["stone_labyrinth"],
            slug="stone-labyrinth-walker",
            title="Stone Labyrinth Walker",
            subtitle="Traced the sacred spiral barefoot.",
            era="Medieval",
            symbol="circle.hexagongrid.fill",
            rarity="rare",
            location_id=LOCATION_IDS["manjyly_ata"],
        ),
        Achievement(
            id=ACHIEVEMENT_IDS["tengri_sky"],
            slug="tengri-sky-witness",
            title="Tengri Sky-Witness",
            subtitle="Saw the sky open over Son-Kol.",
            era="Celestial",
            symbol="cloud.sun.fill",
            rarity="common",
            location_id=LOCATION_IDS["son_kol"],
        ),
    ]
    session.add_all(achievements)

    profile = UserProfile(
        id=PROFILE_ID,
        external_id="me",
        name="Aybek",
        level_label="Wanderer of the Steppe",
        level_number=4,
        xp=2380,
        xp_to_next=3500,
        journeys_completed=1,
        badges_collected=2,
        kilometers_traced=486,
        totem="Bugu",
    )
    session.add(profile)
    session.flush()

    now = datetime.now(timezone.utc)

    session.add_all(
        [
            UserCheckIn(
                user_id=PROFILE_ID,
                location_id=LOCATION_IDS["cholpon_ata"],
                user_latitude=42.6487,
                user_longitude=77.0810,
                distance_meters=18.0,
                xp_awarded=150,
                badge_name="Stone Memory Keeper",
                created_at=now,
            ),
            UserCheckIn(
                user_id=PROFILE_ID,
                location_id=LOCATION_IDS["manjyly_ata"],
                user_latitude=42.1784,
                user_longitude=77.0924,
                distance_meters=24.0,
                xp_awarded=150,
                badge_name="Bugu-Ene Pilgrim",
                created_at=now,
            ),
            UserAchievement(
                user_id=PROFILE_ID,
                achievement_id=ACHIEVEMENT_IDS["saka_scholar"],
                unlocked_at=now,
            ),
            UserAchievement(
                user_id=PROFILE_ID,
                achievement_id=ACHIEVEMENT_IDS["bugu_pilgrim"],
                unlocked_at=now,
            ),
            UserAchievement(
                user_id=PROFILE_ID,
                achievement_id=ACHIEVEMENT_IDS["urker_stargazer"],
                unlocked_at=now,
            ),
            UserAchievement(
                user_id=PROFILE_ID,
                achievement_id=ACHIEVEMENT_IDS["kumys_initiate"],
                unlocked_at=now,
            ),
        ]
    )

    session.add_all(
        [
            LocalizationBundle(
                language_code="en",
                payload={
                    "strings": {
                        "syncNotice": "Tabylga knowledge base synced.",
                        "healingProperties": "Healing Properties",
                        "calendarLegend": "Nomadic Calendar Legend",
                    },
                    "locations": {
                        str(LOCATION_IDS["manjyly_ata"]): {
                            "culturalLegend": "Pilgrims circle the springs and the stone labyrinth to seek clarity, healing, and ancestral blessing.",
                            "healingProperties": ["Eye ailments", "Liver renewal", "Clarity of intention"],
                        },
                        str(LOCATION_IDS["saimaluu_tash"]): {
                            "culturalLegend": "The carved boulders are read as a sky archive, especially the Sun-Chariot petroglyph.",
                            "healingProperties": ["Cosmic alignment", "Artisan sight"],
                        },
                    },
                    "calendar": {
                        "4": {
                            "traditionalMeaning": "The true roe month when foals arrive and fresh kumys begins.",
                            "seasonalActivity": "Renewal rites, spring migrations, and sacred spring visits.",
                        }
                    },
                },
                updated_at=now,
            ),
            LocalizationBundle(
                language_code="ru",
                payload={
                    "strings": {
                        "syncNotice": "База знаний Tabylga синхронизирована.",
                        "healingProperties": "Целебные свойства",
                        "calendarLegend": "Легенда кочевого календаря",
                    },
                    "locations": {
                        str(LOCATION_IDS["manjyly_ata"]): {
                            "culturalLegend": "Паломники обходят источники и каменный лабиринт в поиске ясности, исцеления и благословения предков.",
                            "healingProperties": ["Зрение", "Печень", "Чистота намерения"],
                        },
                        str(LOCATION_IDS["saimaluu_tash"]): {
                            "culturalLegend": "Петроглифы читаются как небесный архив, особенно знак Солнечной колесницы.",
                            "healingProperties": ["Космическая настройка", "Зрение мастера"],
                        },
                    },
                    "calendar": {
                        "4": {
                            "traditionalMeaning": "Истинный месяц косули, когда рождаются жеребята и начинается первый кымыз.",
                            "seasonalActivity": "Обряды обновления, весенние перекочевки и посещение святых источников.",
                        }
                    },
                },
                updated_at=now,
            ),
            LocalizationBundle(
                language_code="ky",
                payload={
                    "strings": {
                        "syncNotice": "Tabylga билим базасы шайкештелди.",
                        "healingProperties": "Дарылык касиеттери",
                        "calendarLegend": "Көчмөн календарынын уламышы",
                    },
                    "locations": {
                        str(LOCATION_IDS["manjyly_ata"]): {
                            "culturalLegend": "Зыяратчылар булактарды жана таш лабиринтти айланып, тунуктук, шыпаа жана ата-бабанын батасын издешет.",
                            "healingProperties": ["Көз оорулары", "Боордун кубаты", "Ниеттин тунуктугу"],
                        },
                        str(LOCATION_IDS["saimaluu_tash"]): {
                            "culturalLegend": "Петроглифтер асман архиви катары окулат, өзгөчө Күн арабасынын белгиси.",
                            "healingProperties": ["Ааламдык шайкештик", "Устанын көзү"],
                        },
                    },
                    "calendar": {
                        "4": {
                            "traditionalMeaning": "Чыныгы куран айы, кулундар туулуп, алгачкы кымыз ачытылган учур.",
                            "seasonalActivity": "Жаңылануу ырымдары, жазгы көч жана ыйык булактарга зыярат.",
                        }
                    },
                },
                updated_at=now,
            ),
        ]
    )

    session.commit()
