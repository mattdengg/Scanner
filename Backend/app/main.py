"""
FastAPI main application entry point for Scanner AI Parser
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes import parser, health
from app.core.config import settings


app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="Scanner AI Parser API"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(health.router, prefix="/api/v1", tags=["health"])
app.include_router(parser.router, prefix="/api/v1", tags=["parser"])


@app.get("/")
async def root():
    return {"message": "Scanner AI Parser API", "version": settings.VERSION}
