from uuid import UUID

from geoalchemy2.shape import to_shape
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import select
from sqlalchemy.orm import Session, selectinload

from ..database import get_db
from ..models import Route
from ..schemas import RouteSchema
from ..services.ors import TRANSPORT_MODE_TO_PROFILE, fetch_navigation, normalize_transport_mode
from ..services.serializers import route_to_schema


router = APIRouter(prefix="/routes", tags=["routes"])


@router.get("", response_model=list[RouteSchema])
def list_routes(
    region: str | None = Query(default=None),
    transport_mode: str | None = Query(default=None),
    duration: str | None = Query(default=None),
    db: Session = Depends(get_db),
) -> list[RouteSchema]:
    statement = select(Route).options(selectinload(Route.locations)).order_by(Route.title)

    normalized_mode = None
    if transport_mode is not None:
        normalized_mode = normalize_transport_mode(transport_mode)
        if normalized_mode not in TRANSPORT_MODE_TO_PROFILE:
            raise HTTPException(status_code=400, detail="transport_mode must be one of: walk, bicycle, car")
        statement = statement.where(Route.transport_modes.any(normalized_mode))

    if region:
        statement = statement.where(Route.region.ilike(f"%{region}%"))

    if duration:
        statement = statement.where(Route.duration_label.ilike(f"%{duration}%"))

    routes = db.scalars(statement).unique().all()
    return [route_to_schema(route) for route in routes]


@router.get("/{route_id}", response_model=RouteSchema)
def get_route(
    route_id: UUID,
    transport_mode: str = Query(default="car"),
    db: Session = Depends(get_db),
) -> RouteSchema:
    route = db.scalar(
        select(Route)
        .options(selectinload(Route.locations))
        .where(Route.id == route_id)
    )
    if route is None:
        raise HTTPException(status_code=404, detail="Route not found.")

    normalized_mode = normalize_transport_mode(transport_mode)
    if normalized_mode not in TRANSPORT_MODE_TO_PROFILE:
        raise HTTPException(status_code=400, detail="transport_mode must be one of: walk, bicycle, car")

    if normalized_mode not in route.transport_modes:
        raise HTTPException(
            status_code=400,
            detail=f"Route does not support {normalized_mode}. Supported modes: {', '.join(route.transport_modes)}",
        )

    coordinates = []
    for location in route.locations:
        shape = to_shape(location.geom)
        coordinates.append((shape.x, shape.y))

    navigation = fetch_navigation(coordinates, normalized_mode)
    return route_to_schema(route, navigation=navigation)
