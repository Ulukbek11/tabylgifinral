from pydantic import BaseModel, ConfigDict
from typing import List, Optional
from uuid import UUID

class LocationPointBase(BaseModel):
    name: str
    name_meaning: Optional[str] = None
    short_summary: Optional[str] = None
    cultural_legend: Optional[str] = None
    heritage_era: Optional[str] = None
    badge_name: Optional[str] = None
    badge_symbol: Optional[str] = None
    healing_properties: List[str] = []

class LocationPointSchema(LocationPointBase):
    id: UUID
    lat: float
    lng: float
    model_config = ConfigDict(from_attributes=True)

class RouteBase(BaseModel):
    title: str
    subtitle: Optional[str] = None
    region: Optional[str] = None
    distance_km: Optional[float] = None
    duration_label: Optional[str] = None
    tags: List[str] = []
    hero_symbol: Optional[str] = None
    legend: Optional[str] = None

class RouteSchema(RouteBase):
    id: UUID
    locations: List[LocationPointSchema]
    model_config = ConfigDict(from_attributes=True)

class NomadicCalendarMonthSchema(BaseModel):
    id: UUID
    kyrgyz_name: str
    gregorian_equivalent: str
    traditional_meaning: str
    celestial_event: str
    seasonal_activity: str
    glyph: str
    month_index: int
    model_config = ConfigDict(from_attributes=True)

class AchievementSchema(BaseModel):
    id: UUID
    title: str
    subtitle: str
    era: str
    symbol: str
    rarity: str
    is_unlocked: bool = False
    model_config = ConfigDict(from_attributes=True)

class UserProfileSchema(BaseModel):
    id: UUID
    name: str
    level: str
    level_number: int
    xp: int
    xp_to_next_level: int
    journeys_completed: int
    badges_collected: int
    kilometers_traced: int
    totem: str
    model_config = ConfigDict(from_attributes=True)
