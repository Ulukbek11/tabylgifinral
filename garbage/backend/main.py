import os
from typing import List, Optional
from uuid import UUID
import httpx
from fastapi import FastAPI, Depends, HTTPException, Header
from sqlalchemy.orm import Session
from sqlalchemy import func
from geoalchemy2.shape import to_shape
from dotenv import load_dotenv

from . import models, schemas, database

load_dotenv()

app = FastAPI(title="Tabylga API")

ORS_API_KEY = os.getenv("OPEN_ROUTE_SERVICE_API_KEY")
ORS_BASE_URL = "https://api.openrouteservice.org/v2"

# --- Helper for PostGIS to Lat/Lng ---
def point_to_coords(geom):
    shape = to_shape(geom)
    return shape.y, shape.x # lat, lng

# --- OpenRouteService Client ---
async def get_ors_directions(coordinates: List[List[float]], profile: str = "driving-car"):
    if not ORS_API_KEY:
        return None
    
    url = f"{ORS_BASE_URL}/directions/{profile}/geojson"
    headers = {
        "Authorization": ORS_API_KEY,
        "Content-Type": "application/json"
    }
    body = {"coordinates": coordinates}
    
    async with httpx.AsyncClient() as client:
        response = await client.post(url, json=body, headers=headers)
        if response.status_code == 200:
            return response.json()
        return None

# --- Endpoints ---

@app.get("/calendar/current", response_model=schemas.NomadicCalendarMonthSchema)
def get_current_month(db: Session = Depends(database.get_db)):
    # Simple logic: map current month (1-12) to nomadic month
    import datetime
    current_month_index = datetime.datetime.now().month
    month = db.query(models.NomadicCalendarMonth).filter_by(month_index=current_month_index).first()
    if not month:
        raise HTTPException(status_code=404, detail="Month not found")
    return month

@app.get("/calendar/year", response_model=List[schemas.NomadicCalendarMonthSchema])
def get_calendar_year(db: Session = Depends(database.get_db)):
    return db.query(models.NomadicCalendarMonth).order_by(models.NomadicCalendarMonth.month_index).all()

@app.get("/routes", response_model=List[schemas.RouteSchema])
def list_routes(
    region: Optional[str] = None, 
    transport_mode: Optional[str] = None, 
    db: Session = Depends(database.get_db)
):
    query = db.query(models.Route)
    if region:
        query = query.filter(models.Route.region.ilike(f"%{region}%"))
    if transport_mode:
        query = query.filter(models.Route.tags.any(transport_mode))
    
    routes = query.all()
    # Transform geom to lat/lng for schema
    for r in routes:
        for loc in r.locations:
            lat, lng = point_to_coords(loc.geom)
            loc.lat = lat
            loc.lng = lng
    return routes

@app.get("/routes/{route_id}", response_model=schemas.RouteSchema)
def get_route(route_id: UUID, db: Session = Depends(database.get_db)):
    route = db.query(models.Route).filter(models.Route.id == route_id).first()
    if not route:
        raise HTTPException(status_code=404, detail="Route not found")
    
    for loc in route.locations:
        lat, lng = point_to_coords(loc.geom)
        loc.lat = lat
        loc.lng = lng
    return route

@app.get("/locations/{location_id}", response_model=schemas.LocationPointSchema)
def get_location(location_id: UUID, db: Session = Depends(database.get_db)):
    loc = db.query(models.LocationPoint).filter(models.LocationPoint.id == location_id).first()
    if not loc:
        raise HTTPException(status_code=404, detail="Location not found")
    
    lat, lng = point_to_coords(loc.geom)
    loc.lat = lat
    loc.lng = lng
    return loc

@app.post("/locations/{location_id}/check-in")
def check_in(location_id: UUID, db: Session = Depends(database.get_db)):
    # For demo, use the first profile or create one
    profile = db.query(models.UserProfile).first()
    if not profile:
        profile = models.UserProfile(name="Wanderer", totem="Bugu")
        db.add(profile)
        db.commit()
        db.refresh(profile)
    
    # Check if already checked in
    existing = db.query(models.UserCheckIn).filter_by(user_id=profile.id, location_id=location_id).first()
    if existing:
        return {"status": "already_claimed", "message": "Badge already collected!"}
    
    check_in = models.UserCheckIn(user_id=profile.id, location_id=location_id)
    db.add(check_in)
    
    # Update profile stats
    profile.xp += 150 # Award XP
    profile.badges_collected += 1
    
    db.commit()
    return {"status": "success", "message": "Sacred badge claimed!", "xp_awarded": 150}

@app.get("/profile/me", response_model=schemas.UserProfileSchema)
def get_profile(db: Session = Depends(database.get_db)):
    profile = db.query(models.UserProfile).first()
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    return profile

@app.get("/directions/{route_id}")
async def get_route_directions(route_id: UUID, db: Session = Depends(database.get_db)):
    route = db.query(models.Route).filter(models.Route.id == route_id).first()
    if not route:
        raise HTTPException(status_code=404, detail="Route not found")
    
    coords = []
    for loc in route.locations:
        shape = to_shape(loc.geom)
        coords.append([shape.x, shape.y]) # ORS expects [lng, lat]
    
    if len(coords) < 2:
        raise HTTPException(status_code=400, detail="Route must have at least 2 locations")
    
    directions = await get_ors_directions(coords)
    if not directions:
        raise HTTPException(status_code=500, detail="Could not fetch directions from ORS")
    
    return directions

@app.get("/localization")
def get_localization(accept_language: str = Header("en"), db: Session = Depends(database.get_db)):
    # In a real app, this would return translations from DB
    return {"status": "ok", "language": accept_language, "message": "Localization synced"}
