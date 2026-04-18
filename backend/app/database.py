import os
import time
from threading import Lock
from typing import Generator

from sqlalchemy import create_engine, text
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker

from .config import (
    CREATE_POSTGIS_EXTENSION,
    DB_CONNECT_RETRIES,
    DB_CONNECT_RETRY_DELAY_SECONDS,
    ENABLE_DB_SEED,
)


DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://tabylga:tabylga@localhost:5432/tabylga",
)

if DATABASE_URL.startswith("postgres://"):
    SQLALCHEMY_DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql+psycopg2://", 1)
elif DATABASE_URL.startswith("postgresql://"):
    SQLALCHEMY_DATABASE_URL = DATABASE_URL.replace("postgresql://", "postgresql+psycopg2://", 1)
else:
    SQLALCHEMY_DATABASE_URL = DATABASE_URL

engine = create_engine(SQLALCHEMY_DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(
    bind=engine,
    autocommit=False,
    autoflush=False,
    expire_on_commit=False,
)


class Base(DeclarativeBase):
    pass


_database_init_lock = Lock()
_database_initialized = False


def get_db() -> Generator[Session, None, None]:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def wait_for_database(
    max_attempts: int = DB_CONNECT_RETRIES,
    delay_seconds: float = DB_CONNECT_RETRY_DELAY_SECONDS,
) -> None:
    last_error: Exception | None = None
    for _ in range(max_attempts):
        try:
            with engine.connect() as connection:
                connection.execute(text("SELECT 1"))
            return
        except Exception as exc:  # pragma: no cover - startup retry path
            last_error = exc
            time.sleep(delay_seconds)

    if last_error is not None:
        raise last_error


def initialize_database() -> None:
    global _database_initialized

    if _database_initialized:
        return

    with _database_init_lock:
        if _database_initialized:
            return

        wait_for_database()

        from . import models  # noqa: F401

        if CREATE_POSTGIS_EXTENSION:
            with engine.begin() as connection:
                connection.execute(text("CREATE EXTENSION IF NOT EXISTS postgis"))

        Base.metadata.create_all(bind=engine)

        if ENABLE_DB_SEED:
            from .seed import seed_database

            with SessionLocal() as session:
                seed_database(session)

        _database_initialized = True
