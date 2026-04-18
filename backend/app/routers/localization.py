from fastapi import APIRouter, Depends, Header
from sqlalchemy import select
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import LocalizationBundle
from ..schemas import LocalizationResponseSchema


router = APIRouter(prefix="/localization", tags=["localization"])


def normalize_language(value: str | None) -> str:
    language = (value or "en").split(",")[0].strip().lower()
    if language.startswith("ru"):
        return "ru"
    if language.startswith("ky"):
        return "ky"
    return "en"


@router.get("", response_model=LocalizationResponseSchema)
def get_localization(
    accept_language: str | None = Header(default="en"),
    db: Session = Depends(get_db),
) -> LocalizationResponseSchema:
    language = normalize_language(accept_language)
    bundle = db.scalar(select(LocalizationBundle).where(LocalizationBundle.language_code == language))
    if bundle is None:
        bundle = db.scalar(select(LocalizationBundle).where(LocalizationBundle.language_code == "en"))

    return LocalizationResponseSchema(
        language=bundle.language_code,
        updated_at=bundle.updated_at,
        payload=bundle.payload,
    )
