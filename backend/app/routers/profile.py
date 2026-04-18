from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session, selectinload

from ..database import get_db
from ..models import Achievement, UserCheckIn, UserProfile
from ..schemas import AchievementSchema, BadgeGalleryItemSchema, UserProfileSchema
from ..services.gamification import get_me_profile
from ..services.serializers import achievement_to_schema, badge_gallery_item_to_schema, profile_to_schema


router = APIRouter(prefix="/profile", tags=["profile"])


@router.get("/me", response_model=UserProfileSchema)
def get_profile(db: Session = Depends(get_db)) -> UserProfileSchema:
    profile = get_me_profile(db)
    if profile is None:
        raise HTTPException(status_code=404, detail="Profile not found.")
    return profile_to_schema(profile)


@router.get("/achievements", response_model=list[AchievementSchema])
def get_profile_achievements(db: Session = Depends(get_db)) -> list[AchievementSchema]:
    profile = get_me_profile(db)
    if profile is None:
        raise HTTPException(status_code=404, detail="Profile not found.")

    unlocked_map = {entry.achievement_id: entry for entry in profile.user_achievements}
    achievements = db.scalars(select(Achievement).order_by(Achievement.rarity.desc(), Achievement.title)).all()
    return [
        achievement_to_schema(achievement, unlocked_map.get(achievement.id))
        for achievement in achievements
    ]


@router.get("/badges", response_model=list[BadgeGalleryItemSchema])
def get_profile_badges(db: Session = Depends(get_db)) -> list[BadgeGalleryItemSchema]:
    profile = db.scalar(
        select(UserProfile)
        .options(selectinload(UserProfile.check_ins).selectinload(UserCheckIn.location))
        .where(UserProfile.external_id == "me")
    )
    if profile is None:
        raise HTTPException(status_code=404, detail="Profile not found.")

    check_ins = sorted(profile.check_ins, key=lambda item: item.created_at, reverse=True)
    return [badge_gallery_item_to_schema(check_in) for check_in in check_ins]
