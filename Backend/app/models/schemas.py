"""
Pydantic schemas for API requests and responses
"""
from pydantic import BaseModel
from typing import Dict, Any, Optional


class ParseResponse(BaseModel):
    """Response model for document parsing"""
    success: bool
    data: Dict[str, Any]
    message: Optional[str] = None


class TextExtractionResponse(BaseModel):
    """Response model for text extraction"""
    text: str


class ClassificationResponse(BaseModel):
    """Response model for document classification"""
    classification: str
    confidence: Optional[float] = None
