# backend_python/database/engine.py
from sqlalchemy import create_engine

# For MVP, we use a simple SQLite database.
# This allows for rapid development without setting up a separate DB server.
DATABASE_URL = "sqlite:///./forex_companion.db"

# In a production environment, you would use a more robust database like PostgreSQL.
# Example for PostgreSQL:
# DATABASE_URL = "postgresql://user:password@postgresserver/db"

# The connect_args argument is specific to SQLite.
# It's needed to ensure that the same connection is used across threads,
# which is important for some web frameworks.
engine = create_engine(
    DATABASE_URL, connect_args={"check_same_thread": False}
)

# If you were using PostgreSQL, you wouldn't need `connect_args`.
# It would look like this:
# engine = create_engine(DATABASE_URL)
