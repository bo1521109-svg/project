from pydantic_settings import BaseSettings
import os


class Settings(BaseSettings):
    PROJECT_NAME: str = "跨境电商独立站数据平台"
    VERSION: str = "1.0.0"
    API_PREFIX: str = "/api/v1"
    DATABASE_URL: str = os.getenv("DATABASE_URL", "postgresql://myuser:mypassword@db:5432/ecommerce_db")
    
    class Config:
        case_sensitive = True


settings = Settings()
