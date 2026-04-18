import os


APP_NAME = os.getenv("APP_NAME", "Tabylga API")
APP_TIMEZONE = os.getenv("APP_TIMEZONE", "Asia/Bishkek")
OPEN_ROUTE_SERVICE_API_KEY = os.getenv("OPEN_ROUTE_SERVICE_API_KEY", "")
ORS_BASE_URL = os.getenv("ORS_BASE_URL", "https://api.openrouteservice.org/v2")
CHECK_IN_RADIUS_METERS = int(os.getenv("CHECK_IN_RADIUS_METERS", "250"))
