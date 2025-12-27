from fastapi import APIRouter
from pydantic import BaseModel
from typing import Optional
from agents.technical_agent import TechnicalAgent
from domain.order_manager import OrderManager

router = APIRouter()
tech_agent = TechnicalAgent()
order_manager = OrderManager()

@router.get("/status")
async def get_status():
    return {"status": "operational", "council": "active"}

@router.post("/analyze/technical")
async def analyze_technical(data: dict):
    # Endpoint for manual trigger from Flutter
    # data expects: {"symbol": "EURUSD", "price": 1.05, "indicators": {...}}
    result = await tech_agent.analyze(data)
    return result

@router.post("/positions/{symbol}/close")
async def close_position(symbol: str, long: bool = True):
    result = await order_manager.close_position(symbol, long=long)
    return result

class PositionUpdate(BaseModel):
    stop_loss: Optional[float] = None
    take_profit: Optional[float] = None

@router.put("/positions/{symbol}")
async def modify_position(symbol: str, update: PositionUpdate):
    result = await order_manager.modify_trade(symbol, update.stop_loss, update.take_profit)
    return result