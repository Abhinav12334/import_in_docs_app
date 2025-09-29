# enhanced_pdf_parser.py
import pdfplumber
import re
import os
from typing import List, Dict, Tuple
from utils import categorize_text, summarize_text, extract_date


def extract_articles_from_pdf(pdf_path: str) -> List[Dict]:
    """
    Enhanced PDF extraction that properly identifies articles, headlines, and content.
    """
    if not os.path.exists(pdf_path):
        raise FileNotFoundError(f"PDF file not found: {pdf_path}")

    try:
        articles = []
        with pdfplumber.open(pdf_path) as pdf:
            full_text = ""
            
            # Extract all text first
            for page in pdf.pages:
                page_text = page.extract_text()
                if page_text:
                    full_text += page_text + "\n"
            
            if not full_text.strip():
                return []
            
            # Split into potential articles
            raw_articles = split_into_articles(full_text)
            
            # Process each article
            for i, raw_article in enumerate(raw_articles, 1):
                processed_article = process_article(raw_article, pdf_path, i)
                if processed_article:
                    articles.append(processed_article)
        
        return articles
    
    except Exception as e:
        raise RuntimeError(f"Error extracting articles from PDF: {str(e)}")


def split_into_articles(text: str) -> List[str]:
    """
    Split text into individual articles based on patterns.
    """
    # Clean up text
    text = re.sub(r'\s+', ' ', text)  # Normalize whitespace
    text = re.sub(r'\n+', '\n', text)  # Remove excessive newlines
    
    # Common patterns that indicate article boundaries
    article_patterns = [
        r'\n[A-Z][A-Za-z\s]{10,50}\n',  # Headlines (ALL CAPS or Title Case)
        r'\n\d{1,2}[-/]\d{1,2}[-/]\d{2,4}',  # Dates
        r'\n(?:Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)',  # Days
        r'\n(?:SPORTS?|POLITICS?|BUSINESS|TECH|ENTERTAINMENT|HEALTH)',  # Category headers
    ]
    
    # Try to split by patterns
    potential_splits = []
    for pattern in article_patterns:
        matches = list(re.finditer(pattern, text, re.IGNORECASE))
        potential_splits.extend([m.start() for m in matches])
    
    # Remove duplicates and sort
    potential_splits = sorted(set(potential_splits))
    
    if not potential_splits:
        # Fallback: split by length if no patterns found
        chunk_size = 1200
        return [text[i:i + chunk_size] for i in range(0, len(text), chunk_size)]
    
    # Split text at identified boundaries
    articles = []
    for i in range(len(potential_splits)):
        start = potential_splits[i]
        end = potential_splits[i + 1] if i + 1 < len(potential_splits) else len(text)
        article_text = text[start:end].strip()
        
        if len(article_text) > 100:  # Only keep substantial content
            articles.append(article_text)
    
    return articles


def extract_headline(text: str) -> str:
    """
    Extract the most likely headline from article text.
    """
    lines = [line.strip() for line in text.split('\n') if line.strip()]
    
    if not lines:
        return "Untitled Article"
    
    # Look for headline patterns
    for line in lines[:5]:  # Check first 5 lines
        # Skip very short lines (likely not headlines)
        if len(line) < 10:
            continue
            
        # Skip lines that look like dates or metadata
        if re.match(r'^\d{1,2}[-/]\d{1,2}[-/]\d{2,4}', line):
            continue
            
        # Skip lines with too many numbers (likely not headlines)
        if len(re.findall(r'\d', line)) > len(line) * 0.3:
            continue
            
        # This looks like a good headline
        if len(line) <= 150:  # Reasonable headline length
            return clean_headline(line)
    
    # Fallback: use first substantial line
    for line in lines:
        if 15 <= len(line) <= 150:
            return clean_headline(line)
    
    # Last resort: use first line
    return clean_headline(lines[0]) if lines else "Untitled Article"


def clean_headline(headline: str) -> str:
    """
    Clean and format headline text.
    """
    # Remove common prefixes/suffixes
    headline = re.sub(r'^(HEADLINE|NEWS|BREAKING|LATEST)[\s:]*', '', headline, flags=re.IGNORECASE)
    headline = re.sub(r'[\s]*-\s*(END|CONT|CONTINUED)$', '', headline, flags=re.IGNORECASE)
    
    # Clean up formatting
    headline = re.sub(r'\s+', ' ', headline)
    headline = headline.strip(' .-')
    
    # Capitalize properly
    if headline.isupper():
        headline = headline.title()
    
    return headline


def process_article(raw_text: str, source_file: str, article_num: int) -> Dict:
    """
    Process raw article text into structured data.
    """
    if len(raw_text.strip()) < 50:  # Skip very short content
        return None
    
    # Extract components
    headline = extract_headline(raw_text)
    category = categorize_text(raw_text)
    summary = summarize_text(raw_text, max_chars=250)
    published_date = extract_date(raw_text)
    
    # Clean content (remove headline if it appears at the start)
    content = raw_text
    first_line = content.split('\n')[0].strip()
    if first_line in headline or headline in first_line:
        content = '\n'.join(content.split('\n')[1:]).strip()
    
    return {
        "title": headline,
        "summary": summary,
        "content": content,
        "category": category,
        "source_file": os.path.basename(source_file),
        "published_date": published_date,
    }


def extract_text_from_pdf(pdf_path: str) -> str:
    """
    Legacy function - maintained for backward compatibility.
    """
    articles = extract_articles_from_pdf(pdf_path)
    return '\n\n---ARTICLE BREAK---\n\n'.join([
        f"TITLE: {article['title']}\n\n{article['content']}" 
        for article in articles
    ])