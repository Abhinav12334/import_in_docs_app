from datetime import datetime
from pydantic import BaseModel
from typing import Optional


class ArticleBase(BaseModel):
    title: str
    summary: Optional[str] = None
    content: str
    category: Optional[str] = None
    source_file: Optional[str] = None
    published_date: Optional[datetime] = None   # use datetime for consistency


class ArticleCreate(ArticleBase):
    pass


class ArticleOut(ArticleBase):
    id: int
    created_at: datetime   # ✅ datetime instead of str

    class Config:
        from_attributes = True   # replaces orm_mode in Pydantic v2
