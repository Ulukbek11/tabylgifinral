# Tabylga API

FastAPI + PostGIS backend for the Tabylga SwiftUI app.

## Start

1. Copy `.env.example` to `.env`.
2. Set `OPEN_ROUTE_SERVICE_API_KEY`.
3. Run:

```bash
docker compose up --build
```

The API will be available at `http://localhost:8000` and Swagger docs at `http://localhost:8000/docs`.

## Main Endpoints

- `GET /calendar/current`
- `GET /calendar/year`
- `GET /routes?region=&transport_mode=&duration=`
- `GET /routes/{id}?transport_mode=car`
- `GET /locations/search?name=&era=&tags=Sacred,Petroglyphs`
- `GET /locations/{id}?origin_lat=&origin_lng=&transport_mode=car`
- `POST /locations/{id}/check-in`
- `GET /profile/me`
- `GET /profile/achievements`
- `GET /profile/badges`
- `GET /localization`

## Check-In Body

```json
{
  "latitude": 42.1786,
  "longitude": 77.0922,
  "radiusMeters": 250
}
```

## Notes

- The service seeds calendar months, four cultural locations, three routes, one demo profile, achievements, and localization bundles on startup.
- Route detail uses OpenRouteService to attach navigation geometry and duration for `walk`, `bicycle`, or `car`.
- Location detail can also attach travel info from an origin coordinate using OpenRouteService.
