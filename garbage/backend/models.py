from sqlalchemy import Column, String, Float, Integer, UUID, ARRAY, ForeignKey, Table, DateTime
from sqlalchemy.orm import relationship, declarative_base
from geoalchemy2 import Geometry
import uuid
import datetime

Base = declarative_base()

# Association table for Route and LocationPoint to maintain order
route_locations = Table(
    "route_locations",
    Base.metadata,
    Column("route_id", UUID(as_uuid=True), ForeignKey("routes.id"), primary_key=True),
    Column("location_id", UUID(as_uuid=True), ForeignKey("locations.id"), primary_key=True),
    Column("order", Integer, nullable=False)
)

class LocationPoint(Base):
    __tablename__ = "locations"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String, nullable=False)
    name_meaning = Column(String)
    short_summary = Column(String)
    cultural_legend = Column(String)
    heritage_era = Column(String)
    geom = Column(Geometry(geometry_type="POINT", srid=4326))
    badge_name = Column(String)
    badge_symbol = Column(String)
    healing_properties = Column(ARRAY(String))

class Route(Base):
    __tablename__ = "routes"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title = Column(String, nullable=False)
    subtitle = Column(String)
    region = Column(String)
    distance_km = Column(Float)
    duration_label = Column(String)
    tags = Column(ARRAY(String))
    hero_symbol = Column(String)
    legend = Column(String)
    
    locations = relationship("LocationPoint", secondary=route_locations, order_by="route_locations.c.order")

class NomadicCalendarMonth(Base):
    __tablename__ = "calendar_months"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    kyrgyz_name = Column(String, nullable=False)
    gregorian_equivalent = Column(String)
    traditional_meaning = Column(String)
    celestial_event = Column(String)
    seasonal_activity = Column(String)
    glyph = Column(String)
    month_index = Column(Integer, unique=True) # 1 to 12

class Achievement(Base):
    __tablename__ = "achievements"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title = Column(String, nullable=False)
    subtitle = Column(String)
    era = Column(String)
    symbol = Column(String)
    rarity = Column(String) # common, rare, legendary

class UserProfile(Base):
    __tablename__ = "profiles"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String, nullable=False)
    level = Column(String)
    level_number = Column(Integer, default=1)
    xp = Column(Integer, default=0)
    xp_to_next_level = Column(Integer, default=1000)
    journeys_completed = Column(Integer, default=0)
    badges_collected = Column(Integer, default=0)
    kilometers_traced = Column(Integer, default=0)
    totem = Column(String)

class UserCheckIn(Base):
    __tablename__ = "user_check_ins"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("profiles.id"))
    location_id = Column(UUID(as_uuid=True), ForeignKey("locations.id"))
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
