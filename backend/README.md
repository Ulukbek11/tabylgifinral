# Tabylga API

FastAPI + PostGIS backend for the Tabylga SwiftUI app.

## Local Start

1. Copy `.env.example` to `.env`.
2. Set `OPEN_ROUTE_SERVICE_API_KEY`.
3. Run:

```bash
docker compose up --build
```

The API will be available at `http://localhost:8000` and Swagger docs at `http://localhost:8000/docs`.

## Vercel Deploy

Vercel can host the FastAPI app, but the database must be an external PostgreSQL instance with PostGIS already enabled. Vercel does not run the local `docker-compose` PostGIS service in production.

The repo is configured for Vercel with:

- root entrypoint: [main.py](/Users/ulukbekasanbekov/projects/hackaton/final/main.py:1)
- root Python dependencies: [requirements.txt](/Users/ulukbekasanbekov/projects/hackaton/final/requirements.txt:1)
- Python version pin: [.python-version](/Users/ulukbekasanbekov/projects/hackaton/final/.python-version:1)
- Vercel function config: [vercel.json](/Users/ulukbekasanbekov/projects/hackaton/final/vercel.json:1)

Set these environment variables in Vercel Project Settings:

- `DATABASE_URL`: external PostgreSQL/PostGIS connection string
- `OPEN_ROUTE_SERVICE_API_KEY`
- `APP_TIMEZONE=Asia/Bishkek`
- `CHECK_IN_RADIUS_METERS=250`
- `ALLOWED_ORIGINS=*`
- `AUTO_INIT_DB=true`
- `ENABLE_DB_SEED=true`
- `CREATE_POSTGIS_EXTENSION=false`

Deploy with Vercel CLI or Git integration:

```bash
vercel
vercel --prod
```

The production API base URL will look like:

```text
https://your-project-name.vercel.app
```

Example Swift base URL:

```swift
let baseURL = URL(string: "https://your-project-name.vercel.app")!
```

Example endpoint from Swift:

```swift
let url = baseURL.appending(path: "/calendar/current")
```

For a native iOS SwiftUI app, HTTPS access to the Vercel domain is enough. Browser CORS is not required for `URLSession`, but the API also exposes configurable CORS for future web clients.

The current SwiftUI app has also been updated to try the deployed backend automatically for routes, calendar, profile, and achievements. It falls back to `MockData` unless `TABYLGA_API_BASE_URL` is configured to your deployed Vercel URL.

The fastest setup is to replace `placeholderBaseURL` in [Tabylga/Tabylga/ViewModels/AppViewModel.swift](/Users/ulukbekasanbekov/projects/hackaton/final/Tabylga/Tabylga/ViewModels/AppViewModel.swift:5) with your deployed Vercel domain.

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

- The service seeds calendar months, four cultural locations, three routes, one demo profile, achievements, and localization bundles when database seeding is enabled.
- Route detail uses OpenRouteService to attach navigation geometry and duration for `walk`, `bicycle`, or `car`.
- Location detail can also attach travel info from an origin coordinate using OpenRouteService.
- On Vercel, `CREATE_POSTGIS_EXTENSION` should stay `false` unless your database user is allowed to install extensions during app startup.
