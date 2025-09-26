# main.py
from fastapi import FastAPI, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from typing import List
import crud, models, schemas
from database import SessionLocal, engine
from pdf_parser import extract_text_from_pdf
import shutil
import os
from datetime import datetime

# Initialize app
app = FastAPI(title="News API")

# Create tables
models.Base.metadata.create_all(bind=engine)

# Directory to save uploaded PDFs
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)


# Dependency for DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.get("/")
def root():
    return {"message": "Backend is running!"}


@app.get("/news/", response_model=List[schemas.ArticleOut])
def read_news(db: Session = Depends(get_db)):
    return crud.get_articles(db)


@app.get("/news/{article_id}", response_model=schemas.ArticleOut)
def read_article(article_id: int, db: Session = Depends(get_db)):
    article = crud.get_article(db, article_id)
    if not article:
        raise HTTPException(status_code=404, detail="Article not found")
    return article


@app.get("/categories/")
def get_categories(db: Session = Depends(get_db)):
    return crud.get_categories(db)


@app.get("/categories/{category}")
def get_articles_by_category(category: str, db: Session = Depends(get_db)):
    return crud.get_articles_by_category(db, category)


@app.get("/search/")
def search_articles(q: str, db: Session = Depends(get_db)):
    return crud.search_articles(db, q)


# ✅ Create a new article manually
@app.post("/news/", response_model=schemas.ArticleOut)
def create_news(article: schemas.ArticleCreate, db: Session = Depends(get_db)):
    return crud.create_article(db=db, article_in=article)


# ✅ Upload PDF → extract text → save as articles
@app.post("/upload-pdf/")
def upload_pdf(file: UploadFile = File(...), db: Session = Depends(get_db)):
    try:
        # Save uploaded PDF
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        # Extract text from PDF
        text = extract_text_from_pdf(file_path)

        if not text.strip():
            raise HTTPException(status_code=400, detail="No text found in PDF")

        # Split text into "articles" (basic version → split by 1000 chars)
        chunks = [text[i:i + 1000] for i in range(0, len(text), 1000)]

        saved_articles = []
        for i, chunk in enumerate(chunks, start=1):
            article_data = schemas.ArticleCreate(
                title=f"Extracted Article {i} from {file.filename}",
                summary=chunk[:200],
                content=chunk,
                category="PDF",
                source_file=file.filename,
                published_date=datetime.utcnow().strftime("%Y-%m-%d")
            )
            saved_articles.append(crud.create_article(db=db, article_in=article_data))

        return {
            "message": f"Uploaded {len(saved_articles)} articles from {file.filename}",
            "articles": saved_articles,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
