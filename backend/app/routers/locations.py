from uuid import UUID

from geoalchemy2.shape import to_shape
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import func, or_, select
from sqlalchemy.orm import Session

from ..config import CHECK_IN_RADIUS_METERS
from ..database import get_db
from ..models import LocationPoint, UserCheckIn
from ..schemas import CheckInRequestSchema, CheckInResponseSchema, LocationPointDetailSchema, LocationPointSchema
from ..services.gamification import apply_level_progression, get_location, get_me_profile, unlock_location_achievement
from ..services.ors import TRANSPORT_MODE_TO_PROFILE, fetch_navigation, normalize_transport_mode
from ..services.serializers import achievement_to_schema, location_detail_to_schema, location_to_schema, profile_to_schema


router = APIRouter(prefix="/locations", tags=["locations"])


@router.get("/search", response_model=list[LocationPointSchema])
def search_locations(
    name: str | None = Query(default=None),
    era: str | None = Query(default=None),
    tags: str | None = Query(default=None, description="Comma-separated tag values."),
    db: Session = Depends(get_db),
) -> list[LocationPointSchema]:
    statement = select(LocationPoint).order_by(LocationPoint.name)

    if name:
        statement = statement.where(LocationPoint.name.ilike(f"%{name}%"))

    if era:
        statement = statement.where(LocationPoint.heritage_era.ilike(f"%{era}%"))

    if tags:
        tag_values = [value.strip() for value in tags.split(",") if value.strip()]
        if tag_values:
            statement = statement.where(or_(*[LocationPoint.tags.any(tag) for tag in tag_values]))

    locations = db.scalars(statement).all()
    return [location_to_schema(location) for location in locations]


@router.get("/{location_id}", response_model=LocationPointDetailSchema)
def get_location_detail(
    location_id: UUID,
    origin_lat: float | None = Query(default=None),
    origin_lng: float | None = Query(default=None),
    transport_mode: str = Query(default="car"),
    db: Session = Depends(get_db),
) -> LocationPointDetailSchema:
    location = get_location(db, location_id)
    if location is None:
        raise HTTPException(status_code=404, detail="Location not found.")

    travel_from_origin = None
    if origin_lat is not None and origin_lng is not None:
        normalized_mode = normalize_transport_mode(transport_mode)
        if normalized_mode not in TRANSPORT_MODE_TO_PROFILE:
            raise HTTPException(status_code=400, detail="transport_mode must be one of: walk, bicycle, car")
        shape = to_shape(location.geom)
        travel_from_origin = fetch_navigation(
            [(origin_lng, origin_lat), (shape.x, shape.y)],
            normalized_mode,
        )

    return location_detail_to_schema(location, travel_from_origin=travel_from_origin)


@router.post("/{location_id}/check-in", response_model=CheckInResponseSchema)
def claim_badge(
    location_id: UUID,
    payload: CheckInRequestSchema,
    db: Session = Depends(get_db),
) -> CheckInResponseSchema:
    profile = get_me_profile(db)
    if profile is None:
        raise HTTPException(status_code=404, detail="Profile not found.")

    location = get_location(db, location_id)
    if location is None:
        raise HTTPException(status_code=404, detail="Location not found.")

    existing = db.scalar(
        select(UserCheckIn).where(
            UserCheckIn.user_id == profile.id,
            UserCheckIn.location_id == location.id,
        )
    )
    if existing is not None:
        return CheckInResponseSchema(
            status="already_claimed",
            badge_name=existing.badge_name,
            xp_awarded=0,
            distance_meters=existing.distance_meters,
            profile=profile_to_schema(profile),
        )

    user_point = func.ST_SetSRID(func.ST_MakePoint(payload.longitude, payload.latitude), 4326)
    distance_meters = db.scalar(
        select(func.ST_DistanceSphere(LocationPoint.geom, user_point)).where(LocationPoint.id == location.id)
    )
    if distance_meters is None:
        raise HTTPException(status_code=500, detail="Could not compute distance to location.")

    allowed_radius = payload.radius_meters or CHECK_IN_RADIUS_METERS
    if distance_meters > allowed_radius:
        raise HTTPException(
            status_code=400,
            detail=(
                f"Check-in denied. User is {round(distance_meters, 2)}m away and must be within "
                f"{allowed_radius}m."
            ),
        )

    xp_awarded = 150
    profile.xp += xp_awarded
    profile.badges_collected += 1
    apply_level_progression(profile)

    check_in = UserCheckIn(
        user_id=profile.id,
        location_id=location.id,
        user_latitude=payload.latitude,
        user_longitude=payload.longitude,
        distance_meters=float(distance_meters),
        xp_awarded=xp_awarded,
        badge_name=location.badge_name,
    )
    db.add(check_in)

    unlocked = unlock_location_achievement(db, profile, location.id)
    db.commit()
    db.refresh(profile)

    return CheckInResponseSchema(
        status="success",
        badge_name=location.badge_name,
        xp_awarded=xp_awarded,
        distance_meters=float(distance_meters),
        profile=profile_to_schema(profile),
        achievement_unlocked=achievement_to_schema(unlocked.achievement, unlocked) if unlocked else None,
    )
