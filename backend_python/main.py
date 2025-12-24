# backend_python/main.py
from fastapi import FastAPI
from .database.models import Base
from .database.engine import engine
from .routers import auth

# This will create the database tables if they don't exist.
# In a production environment, you would use Alembic migrations for this.
Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(auth.router, prefix="/auth", tags=["auth"])

@app.get("/")
def read_root():
    return {"message": "Welcome to Forex Companion Backend"}
