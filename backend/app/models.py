import uuid
from datetime import datetime, timezone

from geoalchemy2 import Geometry
from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, Table, Text, UniqueConstraint
from sqlalchemy.dialects.postgresql import ARRAY, JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .database import Base


route_locations = Table(
    "route_locations",
    Base.metadata,
    Column("route_id", UUID(as_uuid=True), ForeignKey("routes.id", ondelete="CASCADE"), primary_key=True),
    Column("location_id", UUID(as_uuid=True), ForeignKey("location_points.id", ondelete="CASCADE"), primary_key=True),
    Column("stop_order", Integer, nullable=False),
)


class LocationPoint(Base):
    __tablename__ = "location_points"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name: Mapped[str] = mapped_column(String(120), nullable=False, unique=True)
    region: Mapped[str] = mapped_column(String(120), nullable=False)
    name_meaning: Mapped[str] = mapped_column(Text, nullable=False)
    short_summary: Mapped[str] = mapped_column(Text, nullable=False)
    cultural_legend: Mapped[str] = mapped_column(Text, nullable=False)
    heritage_era: Mapped[str] = mapped_column(String(160), nullable=False)
    tags: Mapped[list[str]] = mapped_column(ARRAY(String), nullable=False, default=list)
    geom: Mapped[object] = mapped_column(
        Geometry(geometry_type="POINT", srid=4326, spatial_index=True),
        nullable=False,
    )
    badge_name: Mapped[str] = mapped_column(String(120), nullable=False)
    badge_symbol: Mapped[str] = mapped_column(String(80), nullable=False)
    healing_properties: Mapped[list[str]] = mapped_column(ARRAY(String), nullable=False, default=list)

    achievements: Mapped[list["Achievement"]] = relationship(back_populates="location")
    check_ins: Mapped[list["UserCheckIn"]] = relationship(back_populates="location")


class Route(Base):
    __tablename__ = "routes"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title: Mapped[str] = mapped_column(String(160), nullable=False)
    subtitle: Mapped[str] = mapped_column(Text, nullable=False)
    region: Mapped[str] = mapped_column(String(120), nullable=False)
    distance_km: Mapped[float] = mapped_column(nullable=False)
    duration_label: Mapped[str] = mapped_column(String(80), nullable=False)
    transport_modes: Mapped[list[str]] = mapped_column(ARRAY(String), nullable=False, default=list)
    tags: Mapped[list[str]] = mapped_column(ARRAY(String), nullable=False, default=list)
    hero_symbol: Mapped[str] = mapped_column(String(80), nullable=False)
    legend: Mapped[str] = mapped_column(Text, nullable=False)

    locations: Mapped[list[LocationPoint]] = relationship(
        secondary=route_locations,
        order_by=route_locations.c.stop_order,
    )


class NomadicCalendarMonth(Base):
    __tablename__ = "nomadic_calendar_months"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    kyrgyz_name: Mapped[str] = mapped_column(String(120), nullable=False)
    gregorian_equivalent: Mapped[str] = mapped_column(String(40), nullable=False)
    traditional_meaning: Mapped[str] = mapped_column(Text, nullable=False)
    celestial_event: Mapped[str] = mapped_column(Text, nullable=False)
    seasonal_activity: Mapped[str] = mapped_column(Text, nullable=False)
    glyph: Mapped[str] = mapped_column(String(80), nullable=False)
    month_index: Mapped[int] = mapped_column(Integer, nullable=False, unique=True)


class Achievement(Base):
    __tablename__ = "achievements"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    slug: Mapped[str] = mapped_column(String(120), nullable=False, unique=True)
    title: Mapped[str] = mapped_column(String(160), nullable=False)
    subtitle: Mapped[str] = mapped_column(Text, nullable=False)
    era: Mapped[str] = mapped_column(String(120), nullable=False)
    symbol: Mapped[str] = mapped_column(String(80), nullable=False)
    rarity: Mapped[str] = mapped_column(String(20), nullable=False)
    location_id: Mapped[uuid.UUID | None] = mapped_column(UUID(as_uuid=True), ForeignKey("location_points.id"))

    location: Mapped[LocationPoint | None] = relationship(back_populates="achievements")
    users: Mapped[list["UserAchievement"]] = relationship(back_populates="achievement")


class UserProfile(Base):
    __tablename__ = "user_profiles"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    external_id: Mapped[str] = mapped_column(String(80), nullable=False, unique=True, default="me")
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    level_label: Mapped[str] = mapped_column(String(160), nullable=False)
    level_number: Mapped[int] = mapped_column(Integer, nullable=False, default=1)
    xp: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    xp_to_next: Mapped[int] = mapped_column(Integer, nullable=False, default=1000)
    journeys_completed: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    badges_collected: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    kilometers_traced: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    totem: Mapped[str] = mapped_column(String(80), nullable=False)

    check_ins: Mapped[list["UserCheckIn"]] = relationship(back_populates="user")
    user_achievements: Mapped[list["UserAchievement"]] = relationship(back_populates="user")


class UserCheckIn(Base):
    __tablename__ = "user_check_ins"
    __table_args__ = (UniqueConstraint("user_id", "location_id", name="uq_user_check_in"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("user_profiles.id", ondelete="CASCADE"))
    location_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("location_points.id", ondelete="CASCADE"),
    )
    user_latitude: Mapped[float] = mapped_column(nullable=False)
    user_longitude: Mapped[float] = mapped_column(nullable=False)
    distance_meters: Mapped[float] = mapped_column(nullable=False)
    xp_awarded: Mapped[int] = mapped_column(Integer, nullable=False)
    badge_name: Mapped[str] = mapped_column(String(120), nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        default=lambda: datetime.now(timezone.utc),
    )

    user: Mapped[UserProfile] = relationship(back_populates="check_ins")
    location: Mapped[LocationPoint] = relationship(back_populates="check_ins")


class UserAchievement(Base):
    __tablename__ = "user_achievements"
    __table_args__ = (UniqueConstraint("user_id", "achievement_id", name="uq_user_achievement"),)

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("user_profiles.id", ondelete="CASCADE"))
    achievement_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("achievements.id", ondelete="CASCADE"),
    )
    unlocked_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        default=lambda: datetime.now(timezone.utc),
    )

    user: Mapped[UserProfile] = relationship(back_populates="user_achievements")
    achievement: Mapped[Achievement] = relationship(back_populates="users")


class LocalizationBundle(Base):
    __tablename__ = "localization_bundles"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    language_code: Mapped[str] = mapped_column(String(10), nullable=False, unique=True)
    payload: Mapped[dict] = mapped_column(JSONB, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )
