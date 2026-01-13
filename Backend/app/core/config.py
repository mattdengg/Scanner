"""
Application configuration settings
"""
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    PROJECT_NAME: str = "Scanner AI Parser"
    VERSION: str = "0.1.0"
    API_V1_STR: str = "/api/v1"
    
    # CORS
    ALLOWED_ORIGINS: list[str] = ["*"]
    
    # AI Model settings
    AI_MODEL_NAME: str = "gpt-4"
    AI_MODEL_TEMPERATURE: float = 0.7
    
    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()
