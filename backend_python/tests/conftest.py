import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from backend_python.database.engine import Base

@pytest.fixture(scope="session")
def db_engine():
    """Fixture for a test database engine (in-memory SQLite)."""
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    yield engine
    Base.metadata.drop_all(engine)


@pytest.fixture(scope="function")
def db_session(db_engine):
    """Fixture for a test database session."""
    connection = db_engine.connect()
    transaction = connection.begin()
    Session = sessionmaker(bind=connection)
    session = Session()

    yield session

    session.close()
    transaction.rollback()
    connection.close()
