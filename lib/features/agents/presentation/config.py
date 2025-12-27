from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    GEMINI_API_KEY: str
    BROKER_API_KEY: str
    BROKER_ACCOUNT_ID: str
    DATABASE_URL: str
    ENV: str = "development"
    LOG_LEVEL: str = "INFO"

    class Config:
        env_file = ".env"

settings = Settings()