# database.py
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL = "sqlite:///./news.db"  # ✅ simple SQLite DB (can replace with PostgreSQL/MySQL)

engine = create_engine(
    DATABASE_URL, connect_args={"check_same_thread": False}
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def init_db():
    """Initialize database and create tables."""
    import models  # ensure models are imported before creating tables
    Base.metadata.create_all(bind=engine)
