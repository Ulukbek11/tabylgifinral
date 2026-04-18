from datetime import datetime
from zoneinfo import ZoneInfo

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.orm import Session

from ..config import APP_TIMEZONE
from ..database import get_db
from ..models import NomadicCalendarMonth
from ..schemas import NomadicCalendarMonthSchema


router = APIRouter(prefix="/calendar", tags=["calendar"])


@router.get("/current", response_model=NomadicCalendarMonthSchema)
def get_current_month(db: Session = Depends(get_db)) -> NomadicCalendarMonth:
    current_month = datetime.now(ZoneInfo(APP_TIMEZONE)).month
    month = db.scalar(
        select(NomadicCalendarMonth).where(NomadicCalendarMonth.month_index == current_month)
    )
    if month is None:
        raise HTTPException(status_code=404, detail="Current nomadic month was not found.")
    return month


@router.get("/year", response_model=list[NomadicCalendarMonthSchema])
def get_year_calendar(db: Session = Depends(get_db)) -> list[NomadicCalendarMonth]:
    months = db.scalars(
        select(NomadicCalendarMonth).order_by(NomadicCalendarMonth.month_index)
    ).all()
    return months
