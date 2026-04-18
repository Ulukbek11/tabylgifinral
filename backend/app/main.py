from contextlib import asynccontextmanager

from fastapi import FastAPI

from .config import APP_NAME
from .database import initialize_database
from .routers import calendar, localization, locations, profile, routes


@asynccontextmanager
async def lifespan(_: FastAPI):
    initialize_database()
    yield


app = FastAPI(
    title=APP_NAME,
    version="1.0.0",
    description="FastAPI + PostGIS backend for the Tabylga SwiftUI app.",
    lifespan=lifespan,
)

app.include_router(calendar.router)
app.include_router(routes.router)
app.include_router(locations.router)
app.include_router(profile.router)
app.include_router(localization.router)


@app.get("/health", tags=["system"])
def healthcheck() -> dict[str, str]:
    return {"status": "ok"}
