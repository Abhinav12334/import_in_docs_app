from sqlalchemy.orm import Session
<<<<<<< HEAD
from sqlalchemy import func, desc
import models, schemas
from typing import List, Dict, Optional
=======
import models, schemas
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d

def create_article(db: Session, article_in: schemas.ArticleCreate):
    db_article = models.Article(
        title=article_in.title,
        summary=article_in.summary,
        content=article_in.content,
        category=article_in.category,
        source_file=article_in.source_file,
        published_date=article_in.published_date,
    )
    db.add(db_article)
    db.commit()
    db.refresh(db_article)
    return db_article

def get_articles(db: Session, limit: int = 50, offset: int = 0):
    return (
        db.query(models.Article)
        .order_by(models.Article.created_at.desc())
        .offset(offset)
        .limit(limit)
        .all()
    )

def get_article(db: Session, article_id: int):
    return db.query(models.Article).filter(models.Article.id == article_id).first()

<<<<<<< HEAD
def get_categories(db: Session) -> List[str]:
    """Get list of all unique categories."""
    rows = db.query(models.Article.category).distinct().all()
    return [r[0] for r in rows if r[0]]

def get_categories_with_counts(db: Session) -> List[Dict]:
    """Get categories with article counts."""
    results = (
        db.query(
            models.Article.category,
            func.count(models.Article.id).label('count')
        )
        .filter(models.Article.category.isnot(None))
        .group_by(models.Article.category)
        .order_by(desc('count'))
        .all()
    )
    
    return [
        {"name": category, "count": count, "display_name": category.title()} 
        for category, count in results
    ]

def get_articles_by_category(db: Session, category: str, limit: int = 50, offset: int = 0):
=======
def get_categories(db: Session):
    rows = db.query(models.Article.category).distinct().all()
    return [r[0] for r in rows if r[0]]

def get_articles_by_category(db: Session, category: str, limit: int = 50):
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
    return (
        db.query(models.Article)
        .filter(models.Article.category == category)
        .order_by(models.Article.created_at.desc())
<<<<<<< HEAD
        .offset(offset)
=======
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
        .limit(limit)
        .all()
    )

<<<<<<< HEAD
def search_articles(db: Session, q: str, limit: int = 50, offset: int = 0):
    q_like = f"%{q}%"
    return (
        db.query(models.Article)
        .filter(
            (models.Article.title.ilike(q_like)) | 
            (models.Article.content.ilike(q_like)) |
            (models.Article.summary.ilike(q_like))
        )
        .order_by(models.Article.created_at.desc())
        .offset(offset)
        .limit(limit)
        .all()
    )

def search_articles_by_category(db: Session, category: str, q: str, limit: int = 50, offset: int = 0):
    """Search articles within a specific category."""
    q_like = f"%{q}%"
    return (
        db.query(models.Article)
        .filter(models.Article.category == category)
        .filter(
            (models.Article.title.ilike(q_like)) | 
            (models.Article.content.ilike(q_like)) |
            (models.Article.summary.ilike(q_like))
        )
        .order_by(models.Article.created_at.desc())
        .offset(offset)
        .limit(limit)
        .all()
    )

def get_recent_articles(db: Session, days: int = 7, limit: int = 10):
    """Get most recent articles from the last N days."""
    from datetime import datetime, timedelta
    cutoff_date = datetime.now() - timedelta(days=days)
    
    return (
        db.query(models.Article)
        .filter(models.Article.created_at >= cutoff_date)
=======
def search_articles(db: Session, q: str, limit: int = 50):
    q_like = f"%{q}%"
    return (
        db.query(models.Article)
        .filter((models.Article.title.ilike(q_like)) | (models.Article.content.ilike(q_like)))
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
        .order_by(models.Article.created_at.desc())
        .limit(limit)
        .all()
    )
<<<<<<< HEAD

def get_popular_articles(db: Session, limit: int = 10):
    """Get articles with longest content (proxy for importance)."""
    return (
        db.query(models.Article)
        .order_by(func.length(models.Article.content).desc())
        .limit(limit)
        .all()
    )

def get_database_stats(db: Session) -> Dict:
    """Get overall database statistics."""
    total_articles = db.query(models.Article).count()
    categories_count = db.query(models.Article.category).distinct().count()
    
    # Recent articles (last 24 hours)
    from datetime import datetime, timedelta
    yesterday = datetime.now() - timedelta(days=1)
    recent_count = db.query(models.Article).filter(
        models.Article.created_at >= yesterday
    ).count()
    
    return {
        "total_articles": total_articles,
        "categories_count": categories_count,
        "recent_articles_24h": recent_count,
        "categories": get_categories_with_counts(db)
    }

def delete_article(db: Session, article_id: int) -> bool:
    """Delete an article by ID."""
    article = db.query(models.Article).filter(models.Article.id == article_id).first()
    if article:
        db.delete(article)
        db.commit()
        return True
    return False

def get_articles_by_source(db: Session, source_file: str, limit: int = 50):
    """Get all articles from a specific source file."""
    return (
        db.query(models.Article)
        .filter(models.Article.source_file == source_file)
        .order_by(models.Article.created_at.desc())
        .limit(limit)
        .all()
    )
=======
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
