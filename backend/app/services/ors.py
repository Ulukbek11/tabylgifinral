from typing import Sequence

import httpx

from ..config import OPEN_ROUTE_SERVICE_API_KEY, ORS_BASE_URL


TRANSPORT_MODE_TO_PROFILE = {
    "car": "driving-car",
    "walk": "foot-walking",
    "bicycle": "cycling-regular",
}

TRANSPORT_MODE_ALIASES = {
    "auto": "car",
    "driving": "car",
    "foot": "walk",
    "walking": "walk",
    "bike": "bicycle",
    "cycling": "bicycle",
}


def normalize_transport_mode(value: str | None) -> str:
    normalized = (value or "car").strip().lower()
    return TRANSPORT_MODE_ALIASES.get(normalized, normalized)


def fetch_navigation(coordinates: Sequence[tuple[float, float]], transport_mode: str) -> dict | None:
    normalized_mode = normalize_transport_mode(transport_mode)
    profile = TRANSPORT_MODE_TO_PROFILE.get(normalized_mode)

    if not OPEN_ROUTE_SERVICE_API_KEY or profile is None or len(coordinates) < 2:
        return None

    try:
        response = httpx.post(
            f"{ORS_BASE_URL}/directions/{profile}/geojson",
            headers={
                "Authorization": OPEN_ROUTE_SERVICE_API_KEY,
                "Content-Type": "application/json",
            },
            json={
                "coordinates": [[lng, lat] for lng, lat in coordinates],
            },
            timeout=20.0,
        )
        response.raise_for_status()
    except httpx.HTTPError:
        return None

    payload = response.json()
    features = payload.get("features") or []
    summary = ((features[0].get("properties") or {}).get("summary") or {}) if features else {}

    return {
        "provider": "openrouteservice",
        "transport_mode": normalized_mode,
        "distance_meters": summary.get("distance"),
        "duration_seconds": summary.get("duration"),
        "geojson": payload,
    }
