import asyncio
import json
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from contextlib import asynccontextmanager
from api.endpoints import router as api_router
from core.logger import logger
from agents.technical_agent import TechnicalAgent
from agents.sentiment_agent import SentimentAgent
from agents.synthesis_agent import SynthesisAgent
from agents.macro_agent import MacroAgent
from agents.risk_agent import RiskAgent
from domain.market_data_feed import MarketDataFeed
from domain.order_manager import OrderManager
from domain.portfolio_tracker import PortfolioTracker
from technical_analysis_service import TechnicalAnalysisService
from economic_calendar_service import EconomicCalendarService

# Initialize Scheduler for autonomous loops
scheduler = AsyncIOScheduler()

# Initialize Agents
tech_agent = TechnicalAgent()
sentiment_agent = SentimentAgent()
macro_agent = MacroAgent()
risk_agent = RiskAgent()
synthesis_agent = SynthesisAgent()
market_feed = MarketDataFeed()
order_manager = OrderManager()
portfolio_tracker = PortfolioTracker(order_manager, market_feed)
ta_service = TechnicalAnalysisService()
calendar_service = EconomicCalendarService()

class ConnectionManager:
    def __init__(self):
        self.active_connections: list[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            try:
                await connection.send_text(message)
            except Exception as e:
                logger.error(f"Error broadcasting: {e}")

manager = ConnectionManager()

async def broadcast_portfolio_updates():
    await portfolio_tracker.update()
    metrics = portfolio_tracker.get_metrics()
    await manager.broadcast(json.dumps({"type": "PORTFOLIO_UPDATE", "data": metrics}))

async def autonomous_trade_cycle():
    """
    This function runs every X minutes.
    1. Fetch Data
    2. Run Agents
    3. Check Guardrails
    4. Execute Trade
    """
    symbol = "EUR_USD"
    logger.info(f"Starting autonomous trade cycle for {symbol}...")

    # 1. Fetch Data
    market_data = await market_feed.get_snapshot(symbol)
    current_price = market_data.get("price", 0.0)
    if current_price == 0.0:
        logger.warning(f"No price data for {symbol}. Skipping cycle.")
        return

    # Fetch historical candles and calculate indicators
    candles = await market_feed.get_historical_candles(symbol)
    if not candles:
        logger.warning(f"Failed to fetch historical candles for {symbol}. Skipping cycle.")
        return

    indicators = ta_service.analyze_candles(candles)

    market_context = {
        "symbol": symbol,
        "price": current_price,
        "indicators": indicators
    }
    
    news_context = {
        "symbol": symbol,
        "headlines": [
            "ECB signals potential rate pause as inflation cools",
            "US GDP growth exceeds expectations, boosting dollar"
        ]
    }
    
    # Fetch real economic events
    events = await calendar_service.get_events(symbol, min_impact="MEDIUM")
    macro_context = {
        "symbol": symbol,
        "events": events
    }

    try:
        # 2. Run Agents
        logger.info("Requesting Technical Analysis...")
        tech_report = await tech_agent.analyze(market_context)
        
        logger.info("Requesting Sentiment Analysis...")
        sentiment_report = await sentiment_agent.analyze(news_context)
        
        logger.info("Requesting Macro Analysis...")
        macro_report = await macro_agent.analyze(macro_context)

        # 3. Check Guardrails & Generate Risk Report
        logger.info("Running Risk Checks...")
        risk_context = {
            "symbol": symbol,
            "spread": 1.2, # Mocked
            "account_equity": 10000.0, # Mocked
            "current_drawdown": 0.5 # Mocked
        }
        risk_report = await risk_agent.analyze(risk_context)

        # 4. Synthesis & Final Decision
        logger.info("Convening The Council (Synthesis)...")
        synthesis_context = {
            "symbol": symbol,
            "technical_analysis": tech_report,
            "sentiment_analysis": sentiment_report,
            "macro_analysis": macro_report,
            "risk_analysis": risk_report
        }
        
        final_decision = await synthesis_agent.analyze(synthesis_context)
        
        logger.info(f"COUNCIL DECISION: {final_decision.get('action')} | Confidence: {final_decision.get('confidence')}")
        
        # 5. Execution Logic
        if final_decision.get("action") in ["EXECUTE_BUY", "EXECUTE_SELL"]:
            if final_decision.get("risk_approved", False) and risk_report["approved"]:
                logger.info(f"🚀 EXECUTING TRADE: {final_decision['action']} on {symbol}")
                # await order_manager.place_order(...)
            else:
                logger.info("🛑 Trade blocked: Risk Disapproval or Guardrails failed.")
        else:
            logger.info("😴 No trade action taken (HOLD).")

    except Exception as e:
        logger.error(f"Error in autonomous cycle: {e}")

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    logger.info("Forex Brain starting up...")
    
    # Start Market Data Stream
    stream_task = asyncio.create_task(market_feed.start_stream(["EUR_USD"]))
    
    scheduler.add_job(autonomous_trade_cycle, 'interval', minutes=15)
    scheduler.add_job(broadcast_portfolio_updates, 'interval', seconds=5)
    scheduler.start()
    yield
    # Shutdown
    logger.info("Forex Brain shutting down...")
    market_feed.stop()
    # Allow stream to close gracefully
    await asyncio.sleep(1)
    scheduler.shutdown()

app = FastAPI(title="Forex Companion Brain", lifespan=lifespan)

app.include_router(api_router, prefix="/api/v1")

@app.websocket("/ws/portfolio")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            await websocket.receive_text()
    except WebSocketDisconnect:
        manager.disconnect(websocket)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)