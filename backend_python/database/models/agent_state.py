# backend_python/database/models/agent_state.py
from sqlalchemy import Column, Integer, String, JSON, ForeignKey
from sqlalchemy.orm import relationship
from .base import Base

class AgentState(Base):
    __tablename__ = "agent_states"

    id = Column(Integer, primary_key=True, index=True)
    agent_name = Column(String, index=True, nullable=False)
    # Using JSON type for broader compatibility, though specific dialects
    # like PostgreSQL's JSONB might be more performant.
    state = Column(JSON, nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"))

    owner = relationship("User")