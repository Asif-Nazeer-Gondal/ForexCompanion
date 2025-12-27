import asyncio
import sys
import os

# Add the parent directory to sys.path to allow imports from core and db
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from core.database import engine, Base
from db.models import Trade, AgentLog
from core.logger import logger

async def init_models():
    try:
        logger.info("Creating database tables...")
        async with engine.begin() as conn:
            # Creates all tables defined in models.py
            await conn.run_sync(Base.metadata.create_all)
        logger.info("Database tables created successfully.")
    except Exception as e:
        logger.error(f"Error creating database tables: {e}")
    finally:
        await engine.dispose()

if __name__ == "__main__":
    asyncio.run(init_models())