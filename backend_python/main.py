# backend_python/main.py
from fastapi import FastAPI
from .database.models import Base
from .database.engine import engine
from .routers import auth, agents # Added agents import
from .ai.claude_client import ClaudeAIClient # Added import

# This will create the database tables if they don't exist.
# In a production environment, you would use Alembic migrations for this.
Base.metadata.create_all(bind=engine)

app = FastAPI()

# Initialize ClaudeAIClient at startup
@app.on_event("startup")
async def startup_event():
    app.state.ai_client = ClaudeAIClient()

app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(agents.router, prefix="/agents", tags=["agents"]) # Added agents router

@app.get("/")
def read_root():
    return {"message": "Welcome to Forex Companion Backend"}
