# models.py
from sqlalchemy import Column, Integer, String, Text, DateTime
from sqlalchemy.sql import func
from database import Base


class Article(Base):
    __tablename__ = "articles"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False, index=True)   # headline
    summary = Column(Text, nullable=True)                     # short summary
    content = Column(Text, nullable=False)                    # full article
    category = Column(String(100), index=True)                # sports, politics, etc.
    source_file = Column(String(255), nullable=True)          # optional (PDF name or URL)
    published_date = Column(String(50), nullable=True)        # parsed date if available
    created_at = Column(DateTime(timezone=True), server_default=func.now())
