# main.py
<<<<<<< HEAD
from fastapi import FastAPI, Depends, HTTPException, UploadFile, File, Query
from sqlalchemy.orm import Session
from typing import List, Optional
import crud, models, schemas
from database import SessionLocal, engine
from enhanced_pdf_parser import extract_articles_from_pdf
import shutil
import os
from datetime import datetime
import traceback

# Initialize app
app = FastAPI(title="Enhanced News API", description="News API with intelligent article extraction")
=======
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
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d

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
<<<<<<< HEAD
    return {"message": "Enhanced News Backend is running!", "version": "2.0"}


@app.get("/news/", response_model=List[schemas.ArticleOut])
def read_news(
    category: Optional[str] = Query(None, description="Filter by category"),
    search: Optional[str] = Query(None, description="Search in title and content"),
    limit: int = Query(50, ge=1, le=100),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db)
):
    """
    Enhanced news endpoint with filtering and search capabilities.
    """
    if category and search:
        # Both category and search
        return crud.search_articles_by_category(db, category, search, limit, offset)
    elif category:
        # Category filter only
        return crud.get_articles_by_category(db, category, limit, offset)
    elif search:
        # Search only
        return crud.search_articles(db, search, limit, offset)
    else:
        # All articles
        return crud.get_articles(db, limit, offset)
=======
    return {"message": "Backend is running!"}


@app.get("/news/", response_model=List[schemas.ArticleOut])
def read_news(db: Session = Depends(get_db)):
    return crud.get_articles(db)
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d


@app.get("/news/{article_id}", response_model=schemas.ArticleOut)
def read_article(article_id: int, db: Session = Depends(get_db)):
    article = crud.get_article(db, article_id)
    if not article:
        raise HTTPException(status_code=404, detail="Article not found")
    return article


@app.get("/categories/")
def get_categories(db: Session = Depends(get_db)):
<<<<<<< HEAD
    """Get all available categories with article counts."""
    categories = crud.get_categories_with_counts(db)
    return {"categories": categories}


@app.get("/categories/{category}")
def get_articles_by_category(
    category: str, 
    limit: int = Query(50, ge=1, le=100),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db)
):
    return crud.get_articles_by_category(db, category, limit, offset)


@app.get("/search/")
def search_articles(
    q: str = Query(..., min_length=1),
    category: Optional[str] = None,
    limit: int = Query(50, ge=1, le=100),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db)
):
    """Enhanced search with optional category filtering."""
    if category:
        return crud.search_articles_by_category(db, category, q, limit, offset)
    return crud.search_articles(db, q, limit, offset)


=======
    return crud.get_categories(db)


@app.get("/categories/{category}")
def get_articles_by_category(category: str, db: Session = Depends(get_db)):
    return crud.get_articles_by_category(db, category)


@app.get("/search/")
def search_articles(q: str, db: Session = Depends(get_db)):
    return crud.search_articles(db, q)


# ✅ Create a new article manually
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
@app.post("/news/", response_model=schemas.ArticleOut)
def create_news(article: schemas.ArticleCreate, db: Session = Depends(get_db)):
    return crud.create_article(db=db, article_in=article)


<<<<<<< HEAD
@app.post("/upload-pdf/")
async def upload_pdf(file: UploadFile = File(...), db: Session = Depends(get_db)):
    """
    Enhanced PDF upload with intelligent article extraction.
    """
    file_path = None
    try:
        # Validate file
        if not file.filename:
            raise HTTPException(status_code=400, detail="No filename provided")
            
        if not file.filename.lower().endswith('.pdf'):
            raise HTTPException(status_code=400, detail="Only PDF files are allowed")
        
        # Save uploaded PDF
        file_path = os.path.join(UPLOAD_DIR, file.filename)
        
        # Use async file operations
        with open(file_path, "wb") as buffer:
            content = await file.read()
            buffer.write(content)

        print(f"PDF saved to: {file_path}")
        print(f"File size: {os.path.getsize(file_path)} bytes")

        # Extract articles using enhanced parser
        try:
            articles_data = extract_articles_from_pdf(file_path)
            print(f"Extracted {len(articles_data) if articles_data else 0} articles")
        except Exception as parse_error:
            print(f"PDF parsing error: {str(parse_error)}")
            print(traceback.format_exc())
            raise HTTPException(
                status_code=400, 
                detail=f"Failed to parse PDF: {str(parse_error)}"
            )

        # Check if articles were found
        if not articles_data or len(articles_data) == 0:
            raise HTTPException(
                status_code=400, 
                detail="No articles found in PDF. The PDF might be empty, scanned, or have an incompatible format."
            )

        # Save articles to database
        saved_articles = []
        for idx, article_data in enumerate(articles_data):
            try:
                # Validate required fields
                if not article_data.get("title"):
                    article_data["title"] = f"Article {idx + 1} from {file.filename}"
                
                if not article_data.get("content"):
                    print(f"Skipping article {idx + 1}: No content")
                    continue
                
                # Ensure all required fields have default values
                article_create = schemas.ArticleCreate(
                    title=article_data.get("title", f"Article {idx + 1}"),
                    summary=article_data.get("summary", article_data.get("content", "")[:500]),
                    content=article_data.get("content", ""),
                    category=article_data.get("category", "general"),
                    source_file=article_data.get("source_file", file.filename),
                    published_date=article_data.get("published_date")
                )
                
                saved_article = crud.create_article(db=db, article_in=article_create)
                saved_articles.append(saved_article)
                print(f"Saved article {idx + 1}: {article_data.get('title')}")
                
            except Exception as save_error:
                print(f"Error saving article {idx + 1}: {str(save_error)}")
                print(traceback.format_exc())
                # Continue with other articles instead of failing completely
                continue

        if not saved_articles:
            raise HTTPException(
                status_code=400, 
                detail="No valid articles could be extracted and saved from the PDF"
            )

        # Get unique categories
        categories_found = list(set(
            article.category for article in saved_articles if article.category
        ))

        return {
            "message": f"Successfully extracted and saved {len(saved_articles)} articles from {file.filename}",
            "articles_count": len(saved_articles),
            "articles": [
                {
                    "id": article.id,
                    "title": article.title,
                    "category": article.category,
                    "summary": article.summary[:200] if article.summary else ""
                }
                for article in saved_articles[:3]
            ],  # Return first 3 as preview
            "categories_found": categories_found
        }

    except HTTPException:
        # Re-raise HTTP exceptions as-is
        raise
    except Exception as e:
        # Log the full error
        print(f"Unexpected error in upload_pdf: {str(e)}")
        print(traceback.format_exc())
        raise HTTPException(
            status_code=500, 
            detail=f"Processing error: {str(e)}"
        )
    finally:
        # Clean up uploaded file (optional - comment out if you want to keep files)
        # if file_path and os.path.exists(file_path):
        #     try:
        #         os.remove(file_path)
        #     except Exception as cleanup_error:
        #         print(f"Could not delete file: {cleanup_error}")
        pass


@app.get("/stats/")
def get_stats(db: Session = Depends(get_db)):
    """Get database statistics."""
    return crud.get_database_stats(db)


@app.delete("/news/{article_id}")
def delete_article(article_id: int, db: Session = Depends(get_db)):
    """Delete an article."""
    success = crud.delete_article(db, article_id)
    if not success:
        raise HTTPException(status_code=404, detail="Article not found")
    return {"message": "Article deleted successfully"}
=======
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
>>>>>>> 3600edf4a35782f3b4b0fe2c1a6bf946c2bd539d
