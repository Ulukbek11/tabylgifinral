from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import ALLOWED_ORIGINS, APP_NAME, AUTO_INIT_DB
from .database import initialize_database
from .routers import calendar, localization, locations, profile, routes


@asynccontextmanager
async def lifespan(_: FastAPI):
    if AUTO_INIT_DB:
        try:
            initialize_database()
        except Exception as e:
            print(f"WARNING: Database initialization failed: {e}")
    yield


app = FastAPI(
    title=APP_NAME,
    version="1.0.0",
    description="FastAPI + PostGIS backend for the Tabylga SwiftUI app.",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(calendar.router)
app.include_router(routes.router)
app.include_router(locations.router)
app.include_router(profile.router)
app.include_router(localization.router)


@app.get("/", tags=["system"])
def root() -> dict[str, str]:
    return {
        "name": APP_NAME,
        "status": "ok",
        "docs": "/docs",
        "health": "/health",
    }


@app.get("/health", tags=["system"])
def healthcheck() -> dict[str, str]:
    return {"status": "ok"}
