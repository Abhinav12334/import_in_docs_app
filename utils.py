# nlp_utils.py
import re
from dateutil import parser as dateparser
from typing import Optional

CATEGORY_KEYWORDS = {
    "sports": ["football", "cricket", "match", "score", "goal", "tournament", "league", "player", "win", "loss"],
    "politics": ["election", "minister", "president", "government", "parliament", "congress", "party", "senate", "mp", "policy"],
    "business": ["market", "stock", "economy", "company", "shares", "finance", "business", "quarter", "revenue"],
    "technology": ["technology", "tech", "ai", "software", "app", "startup", "cyber", "gadget", "device"],
    "entertainment": ["movie", "film", "actor", "actress", "celebrity", "music", "song", "festival"],
    "health": ["health", "covid", "vaccine", "disease", "hospital", "doctor"],
}


def categorize_text(text: str) -> str:
    text_l = text.lower()
    scores = {}
    for cat, kws in CATEGORY_KEYWORDS.items():
        count = sum(text_l.count(k) for k in kws)
        if count:
            scores[cat] = count
    if not scores:
        return "general"
    return max(scores.items(), key=lambda x: x[1])[0]


def summarize_text(text: str, max_chars: int = 200) -> str:
    if not text:
        return ""
    sentences = re.split(r'[\.\?\!]\s+', text.strip())
    if sentences:
        s = sentences[0]
        if len(s) <= max_chars:
            return s.strip()
    return text.strip()[:max_chars]


def extract_date(text: str) -> Optional[str]:
    patterns = [
        r"\b\d{4}-\d{2}-\d{2}\b",
        r"\b\d{1,2}[\-/]\d{1,2}[\-/]\d{2,4}\b",
        r"\b(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Sept|Oct|Nov|Dec)[a-z]*\b\s+\d{1,2},?\s+\d{4}",
        r"\b\d{1,2}\s+(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{4}\b",
    ]
    for pat in patterns:
        m = re.search(pat, text, flags=re.IGNORECASE)
        if m:
            candidate = m.group(0)
            try:
                dt = dateparser.parse(candidate, fuzzy=True)
                return dt.date().isoformat()
            except Exception:
                return candidate
    return None
