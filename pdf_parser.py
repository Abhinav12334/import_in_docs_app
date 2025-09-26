# pdf_parser.py
import pdfplumber
import os


def extract_text_from_pdf(pdf_path: str) -> str:
    """
    Extract text from PDF file with error handling.
    """
    if not os.path.exists(pdf_path):
        raise FileNotFoundError(f"PDF file not found: {pdf_path}")

    try:
        text = ''
        with pdfplumber.open(pdf_path) as pdf:
            for i, page in enumerate(pdf.pages):
                page_text = page.extract_text()
                if page_text:
                    text += page_text + '\n'
        return text.strip()
    except Exception as e:
        raise RuntimeError(f"Error extracting text from PDF: {str(e)}")
