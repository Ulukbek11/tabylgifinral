import os


def env_bool(name: str, default: str = "false") -> bool:
    value = os.getenv(name, default).strip().lower()
    return value in {"1", "true", "yes", "on"}


def env_list(name: str, default: str = "*") -> list[str]:
    value = os.getenv(name, default)
    items = [item.strip() for item in value.split(",") if item.strip()]
    return items or ["*"]


APP_NAME = os.getenv("APP_NAME", "Tabylga API")
APP_TIMEZONE = os.getenv("APP_TIMEZONE", "Asia/Bishkek")
OPEN_ROUTE_SERVICE_API_KEY = os.getenv("OPEN_ROUTE_SERVICE_API_KEY", "")
ORS_BASE_URL = os.getenv("ORS_BASE_URL", "https://api.openrouteservice.org/v2")
CHECK_IN_RADIUS_METERS = int(os.getenv("CHECK_IN_RADIUS_METERS", "250"))
ALLOWED_ORIGINS = env_list("ALLOWED_ORIGINS", "*")
IS_VERCEL = os.getenv("VERCEL") == "1"
AUTO_INIT_DB = env_bool("AUTO_INIT_DB", "false" if IS_VERCEL else "true")
ENABLE_DB_SEED = env_bool("ENABLE_DB_SEED", "false" if IS_VERCEL else "true")
CREATE_POSTGIS_EXTENSION = env_bool("CREATE_POSTGIS_EXTENSION", "false")
DB_CONNECT_RETRIES = int(os.getenv("DB_CONNECT_RETRIES", "12"))
DB_CONNECT_RETRY_DELAY_SECONDS = float(os.getenv("DB_CONNECT_RETRY_DELAY_SECONDS", "1.5"))
