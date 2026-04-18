import uuid
from sqlalchemy.orm import Session
from geoalchemy2.elements import WKTElement
from .database import engine, SessionLocal
from .models import Base, LocationPoint, Route, NomadicCalendarMonth, Achievement, UserProfile, route_locations

def init_db():
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)

    db = SessionLocal()
    try:
        # --- Locations ---
        cholpon_ata = LocationPoint(
            id=uuid.uuid4(),
            name="Cholpon-Ata",
            name_meaning="Father of the Morning Star (Venus) — the dawn shepherd watching over the flocks.",
            short_summary="Iron Age petroglyph sanctuary on the north shore of Issyk-Kul.",
            cultural_legend="An open-air stone sanctuary of the Saka-Scythian nomads...",
            heritage_era="Iron Age · Saka Animal Style",
            geom=WKTElement("POINT(77.0811 42.6486)", srid=4326),
            badge_name="Stone Memory Keeper",
            badge_symbol="scroll.fill",
            healing_properties=["Vision of ancestors", "Orientation by stars"]
        )
        
        manjyly_ata = LocationPoint(
            id=uuid.uuid4(),
            name="Manjyly-Ata",
            name_meaning="Father Manjyly — guardian of the southern shore...",
            short_summary="Sacred valley of labyrinths and healing springs on the south shore of Issyk-Kul.",
            cultural_legend="A valley of stone labyrinths and natural springs...",
            heritage_era="Ongoing sacred pilgrimage · Medieval Sufi syncretism",
            geom=WKTElement("POINT(77.0922 42.1786)", srid=4326),
            badge_name="Bugu-Ene Pilgrim",
            badge_symbol="drop.fill",
            healing_properties=["Eye ailments", "Liver renewal", "Clarity of intention"]
        )

        saimaluu_tash = LocationPoint(
            id=uuid.uuid4(),
            name="Saimaluu-Tash",
            name_meaning="The Embroidered Stones — a mountain pass carpeted with carved boulders.",
            short_summary="The largest open-air petroglyph gallery in Central Asia.",
            cultural_legend="Over 10,000 petroglyphs spanning the Bronze Age to the Middle Ages...",
            heritage_era="Bronze Age · UNESCO tentative list",
            geom=WKTElement("POINT(73.7500 41.2167)", srid=4326),
            badge_name="Sun-Chariot Seeker",
            badge_symbol="sun.max.fill",
            healing_properties=["Cosmic alignment", "Artisan sight"]
        )

        song_kol = LocationPoint(
            id=uuid.uuid4(),
            name="Son-Kol",
            name_meaning="The Last Lake — final high-altitude pasture before the sky.",
            short_summary="Alpine jailoo at 3,016 m — the living summer pasture of the nomads.",
            cultural_legend="A crescent of living yurts at 3,016 meters...",
            heritage_era="Living tradition · Jailoo pastoralism",
            geom=WKTElement("POINT(75.1264 41.8375)", srid=4326),
            badge_name="Jailoo Dweller",
            badge_symbol="tent.fill",
            healing_properties=["Silence", "Altitude clarity"]
        )

        db.add_all([cholpon_ata, manjyly_ata, saimaluu_tash, song_kol])
        db.flush()

        # --- Routes ---
        issyk_kul_route = Route(
            id=uuid.uuid4(),
            title="Mysteries of Issyk-Kul",
            subtitle="From the Morning Star to the Mother Deer",
            region="Issyk-Kul Oblast",
            distance_km=218,
            duration_label="Full Day",
            tags=["Auto", "Full Day", "Sacred", "Petroglyphs"],
            hero_symbol="water.waves",
            legend="A circuit of the warm lake that never freezes..."
        )
        db.add(issyk_kul_route)
        db.flush()
        
        # Link locations to route
        db.execute(route_locations.insert().values(route_id=issyk_kul_route.id, location_id=cholpon_ata.id, order=0))
        db.execute(route_locations.insert().values(route_id=issyk_kul_route.id, location_id=manjyly_ata.id, order=1))

        # --- Calendar ---
        months_data = [
            ("Jalgan Kuran", "March", "leaf.arrow.triangle.circlepath", 3),
            ("Chyn Kuran", "April", "moon.stars.fill", 4),
            ("Bugu", "May", "sparkle", 5),
            ("Kulja", "June", "sun.max.fill", 6),
            ("Tekey", "July", "mountain.2.fill", 7),
            ("Bash-Oona", "August", "leaf.fill", 8),
            ("Ayak-Oona", "September", "leaf.arrow.circlepath", 9),
            ("Toguzdun Ayı", "October", "9.circle.fill", 10),
            ("Jetinin Ayı", "November", "7.circle.fill", 11),
            ("Beshtin Ayı", "December", "snowflake", 12),
            ("Üchtün Ayı", "January", "cloud.snow.fill", 1),
            ("Birdin Ayı", "February", "bird.fill", 2),
        ]
        
        for name, greg, glyph, idx in months_data:
            m = NomadicCalendarMonth(
                kyrgyz_name=name,
                gregorian_equivalent=greg,
                glyph=glyph,
                month_index=idx,
                traditional_meaning="Traditional meaning here...",
                celestial_event="Celestial event here...",
                seasonal_activity="Seasonal activity here..."
            )
            db.add(m)

        # --- User Profile ---
        aybek = UserProfile(
            name="Aybek",
            level="Wanderer of the Steppe",
            level_number=4,
            xp=2380,
            xp_to_next_level=3500,
            journeys_completed=7,
            badges_collected=12,
            kilometers_traced=486,
            totem="Bugu"
        )
        db.add(aybek)

        db.commit()
        print("Database initialized successfully.")
    except Exception as e:
        db.rollback()
        print(f"Error initializing database: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    init_db()
