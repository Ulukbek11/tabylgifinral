from geoalchemy2.shape import to_shape

from ..models import Achievement, LocationPoint, Route, UserAchievement, UserCheckIn, UserProfile
from ..schemas import (
    AchievementSchema,
    BadgeGalleryItemSchema,
    BadgeSchema,
    CoordinateSchema,
    LocationPointDetailSchema,
    LocationPointSchema,
    NavigationSchema,
    ProfileStatsSchema,
    RouteSchema,
    UserProfileSchema,
)


def geometry_to_coordinate(geometry) -> CoordinateSchema:
    shape = to_shape(geometry)
    return CoordinateSchema(lat=shape.y, lng=shape.x)


def location_to_schema(location: LocationPoint) -> LocationPointSchema:
    return LocationPointSchema(
        id=location.id,
        name=location.name,
        region=location.region,
        name_meaning=location.name_meaning,
        short_summary=location.short_summary,
        cultural_legend=location.cultural_legend,
        heritage_era=location.heritage_era,
        tags=list(location.tags or []),
        coordinate=geometry_to_coordinate(location.geom),
        badge=BadgeSchema(name=location.badge_name, symbol=location.badge_symbol),
        healing_properties=list(location.healing_properties or []),
    )


def location_detail_to_schema(
    location: LocationPoint,
    travel_from_origin: dict | None = None,
) -> LocationPointDetailSchema:
    base = location_to_schema(location)
    return LocationPointDetailSchema(
        **base.model_dump(),
        travel_from_origin=NavigationSchema(**travel_from_origin) if travel_from_origin else None,
    )


def route_to_schema(route: Route, navigation: dict | None = None) -> RouteSchema:
    return RouteSchema(
        id=route.id,
        title=route.title,
        subtitle=route.subtitle,
        region=route.region,
        distance_km=route.distance_km,
        duration_label=route.duration_label,
        transport_modes=list(route.transport_modes or []),
        tags=list(route.tags or []),
        hero_symbol=route.hero_symbol,
        legend=route.legend,
        locations=[location_to_schema(location) for location in route.locations],
        navigation=NavigationSchema(**navigation) if navigation else None,
    )


def profile_to_schema(profile: UserProfile) -> UserProfileSchema:
    return UserProfileSchema(
        id=profile.id,
        name=profile.name,
        level_label=profile.level_label,
        level_number=profile.level_number,
        stats=ProfileStatsSchema(
            xp=profile.xp,
            xp_to_next=profile.xp_to_next,
            kilometers=profile.kilometers_traced,
        ),
        totem=profile.totem,
        journeys_completed=profile.journeys_completed,
        badges_collected=profile.badges_collected,
    )


def achievement_to_schema(
    achievement: Achievement,
    user_achievement: UserAchievement | None = None,
) -> AchievementSchema:
    return AchievementSchema(
        id=achievement.id,
        title=achievement.title,
        subtitle=achievement.subtitle,
        era=achievement.era,
        symbol=achievement.symbol,
        rarity=achievement.rarity,
        is_unlocked=user_achievement is not None,
        unlocked_at=user_achievement.unlocked_at if user_achievement else None,
    )


def badge_gallery_item_to_schema(check_in: UserCheckIn) -> BadgeGalleryItemSchema:
    return BadgeGalleryItemSchema(
        check_in_id=check_in.id,
        location_id=check_in.location.id,
        location_name=check_in.location.name,
        heritage_era=check_in.location.heritage_era,
        claimed_at=check_in.created_at,
        coordinate=geometry_to_coordinate(check_in.location.geom),
        badge=BadgeSchema(name=check_in.badge_name, symbol=check_in.location.badge_symbol),
    )
