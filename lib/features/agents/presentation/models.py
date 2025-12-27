from sqlalchemy import Column, Integer, String, Float, DateTime, JSON, Boolean, Text
from sqlalchemy.sql import func
from core.database import Base

class Trade(Base):
    __tablename__ = "trades"

    id = Column(Integer, primary_key=True, index=True)
    oanda_id = Column(String, unique=True, index=True, nullable=True)
    symbol = Column(String, index=True, nullable=False)
    units = Column(Integer, nullable=False)
    direction = Column(String, nullable=False)  # BUY / SELL
    
    entry_price = Column(Float, nullable=False)
    stop_loss = Column(Float, nullable=True)
    take_profit = Column(Float, nullable=True)
    
    close_price = Column(Float, nullable=True)
    pnl = Column(Float, default=0.0)
    
    status = Column(String, default="OPEN", index=True)  # OPEN, CLOSED, CANCELLED
    
    opened_at = Column(DateTime(timezone=True), server_default=func.now())
    closed_at = Column(DateTime(timezone=True), nullable=True)

class AgentLog(Base):
    """
    The 'Black Box' recorder. Stores every thought process of the agents.
    """
    __tablename__ = "agent_logs"

    id = Column(Integer, primary_key=True, index=True)
    timestamp = Column(DateTime(timezone=True), server_default=func.now(), index=True)
    
    cycle_id = Column(String, index=True) # To group logs from the same 15-min cycle
    agent_name = Column(String, index=True) # Technical, Sentiment, Synthesis
    symbol = Column(String, index=True)
    
    input_context = Column(JSON) # What the agent saw
    output_decision = Column(JSON) # What the agent decided (JSON response)
    
    raw_prompt = Column(Text, nullable=True) # The exact prompt sent to Gemini
    raw_response = Column(Text, nullable=True) # The exact text response from Gemini