from datetime import datetime, timezone
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.orm import Session, selectinload

from ..models import Achievement, LocationPoint, UserAchievement, UserProfile


LEVEL_LABELS = {
    1: "Steppe Listener",
    2: "Caravan Walker",
    3: "Trail Keeper",
    4: "Wanderer of the Steppe",
    5: "Sky Reader",
    6: "Guardian of the Jailoo",
    7: "Master of the Nomadic Path",
}


def get_me_profile(session: Session) -> UserProfile | None:
    statement = (
        select(UserProfile)
        .options(selectinload(UserProfile.user_achievements).selectinload(UserAchievement.achievement))
        .where(UserProfile.external_id == "me")
    )
    return session.scalar(statement)


def get_location(session: Session, location_id: UUID) -> LocationPoint | None:
    return session.scalar(select(LocationPoint).where(LocationPoint.id == location_id))


def apply_level_progression(profile: UserProfile) -> None:
    while profile.xp >= profile.xp_to_next:
        profile.level_number += 1
        profile.xp_to_next += 1200
        profile.level_label = LEVEL_LABELS.get(profile.level_number, "Master of the Nomadic Path")


def unlock_location_achievement(
    session: Session,
    profile: UserProfile,
    location_id: UUID,
) -> UserAchievement | None:
    unlocked_ids = {item.achievement_id for item in profile.user_achievements}
    achievements = session.scalars(
        select(Achievement).where(Achievement.location_id == location_id).order_by(Achievement.title)
    ).all()

    for achievement in achievements:
        if achievement.id in unlocked_ids:
            continue

        user_achievement = UserAchievement(
            user_id=profile.id,
            achievement_id=achievement.id,
            unlocked_at=datetime.now(timezone.utc),
            achievement=achievement,
        )
        session.add(user_achievement)
        profile.user_achievements.append(user_achievement)
        return user_achievement

    return None
