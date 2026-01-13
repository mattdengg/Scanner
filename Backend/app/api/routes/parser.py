"""
Parser API routes
"""
from fastapi import APIRouter, UploadFile, File, HTTPException
from typing import Dict, Any

from app.services.ai_parser import AIParserService
from app.models.schemas import ParseResponse


router = APIRouter()
parser_service = AIParserService()


@router.post("/parse", response_model=ParseResponse)
async def parse_document(
    file: UploadFile = File(...),
) -> Dict[str, Any]:
    """
    Parse uploaded document using AI
    """
    try:
        contents = await file.read()
        result = await parser_service.parse_document(
            document_data=contents,
            document_type=file.content_type or "unknown"
        )
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/extract-text")
async def extract_text(
    file: UploadFile = File(...),
) -> Dict[str, str]:
    """
    Extract text from image/document
    """
    try:
        contents = await file.read()
        text = await parser_service.extract_text(contents)
        return {"text": text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/classify")
async def classify_document(
    file: UploadFile = File(...),
) -> Dict[str, str]:
    """
    Classify document type
    """
    try:
        contents = await file.read()
        classification = await parser_service.classify_document(contents)
        return {"classification": classification}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
