from sqlalchemy.orm import Session
import models, schemas

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

def get_categories(db: Session):
    rows = db.query(models.Article.category).distinct().all()
    return [r[0] for r in rows if r[0]]

def get_articles_by_category(db: Session, category: str, limit: int = 50):
    return (
        db.query(models.Article)
        .filter(models.Article.category == category)
        .order_by(models.Article.created_at.desc())
        .limit(limit)
        .all()
    )

def search_articles(db: Session, q: str, limit: int = 50):
    q_like = f"%{q}%"
    return (
        db.query(models.Article)
        .filter((models.Article.title.ilike(q_like)) | (models.Article.content.ilike(q_like)))
        .order_by(models.Article.created_at.desc())
        .limit(limit)
        .all()
    )
