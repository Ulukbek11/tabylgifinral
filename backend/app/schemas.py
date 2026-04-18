from datetime import datetime
from typing import Any
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field


def to_camel(value: str) -> str:
    parts = value.split("_")
    return parts[0] + "".join(word.capitalize() for word in parts[1:])


class CamelModel(BaseModel):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True, from_attributes=True)


class CoordinateSchema(CamelModel):
    lat: float
    lng: float


class BadgeSchema(CamelModel):
    name: str
    symbol: str


class NavigationSchema(CamelModel):
    provider: str = "openrouteservice"
    transport_mode: str
    distance_meters: float | None = None
    duration_seconds: float | None = None
    geojson: dict[str, Any] | None = None


class NomadicCalendarMonthSchema(CamelModel):
    id: UUID
    kyrgyz_name: str
    gregorian_equivalent: str
    traditional_meaning: str
    celestial_event: str
    seasonal_activity: str
    glyph: str
    month_index: int


class LocationPointSchema(CamelModel):
    id: UUID
    name: str
    region: str
    name_meaning: str
    short_summary: str
    cultural_legend: str
    heritage_era: str
    tags: list[str]
    coordinate: CoordinateSchema
    badge: BadgeSchema
    healing_properties: list[str]


class LocationPointDetailSchema(LocationPointSchema):
    travel_from_origin: NavigationSchema | None = None


class RouteSchema(CamelModel):
    id: UUID
    title: str
    subtitle: str
    region: str
    distance_km: float
    duration_label: str
    transport_modes: list[str]
    tags: list[str]
    hero_symbol: str
    legend: str
    locations: list[LocationPointSchema]
    navigation: NavigationSchema | None = None


class ProfileStatsSchema(CamelModel):
    xp: int
    xp_to_next: int
    kilometers: int


class UserProfileSchema(CamelModel):
    id: UUID
    name: str
    level_label: str
    level_number: int
    stats: ProfileStatsSchema
    totem: str
    journeys_completed: int
    badges_collected: int


class AchievementSchema(CamelModel):
    id: UUID
    title: str
    subtitle: str
    era: str
    symbol: str
    rarity: str
    is_unlocked: bool
    unlocked_at: datetime | None = None


class BadgeGalleryItemSchema(CamelModel):
    check_in_id: UUID
    location_id: UUID
    location_name: str
    heritage_era: str
    claimed_at: datetime
    coordinate: CoordinateSchema
    badge: BadgeSchema


class CheckInRequestSchema(CamelModel):
    latitude: float
    longitude: float
    radius_meters: int | None = Field(default=None, ge=25, le=1000)


class CheckInResponseSchema(CamelModel):
    status: str
    badge_name: str
    xp_awarded: int
    distance_meters: float
    profile: UserProfileSchema
    achievement_unlocked: AchievementSchema | None = None


class LocalizationResponseSchema(CamelModel):
    language: str
    updated_at: datetime
    payload: dict[str, Any]
