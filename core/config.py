from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    PROJECT_NAME: str = "Myproject"
    VERSION: str = "1.0.0"
    API_PREFIX: str = "/api"
    
    class Config:
        case_sensitive = True


settings = Settings()
