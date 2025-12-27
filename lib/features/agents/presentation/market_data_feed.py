import asyncio
import json
import httpx
from core.config import settings
from core.logger import logger
from typing import Dict, Callable, List, Optional

class MarketDataFeed:
    def __init__(self):
        self.api_key = settings.BROKER_API_KEY
        self.account_id = settings.BROKER_ACCOUNT_ID
        # Default to Oanda demo stream
        self.base_stream_url = "https://stream-fxpractice.oanda.com/v3"
        self.base_api_url = "https://api-fxpractice.oanda.com/v3"
        if settings.ENV == "production":
             self.base_stream_url = "https://stream-fxtrade.oanda.com/v3"
             self.base_api_url = "https://api-fxtrade.oanda.com/v3"
        
        self.latest_prices: Dict[str, float] = {}
        self.is_running = False
        self.subscribers: List[Callable] = []

    async def start_stream(self, symbols: List[str]):
        """
        Connects to Oanda's pricing stream and updates latest_prices in real-time.
        """
        self.is_running = True
        instruments = ",".join(symbols)
        endpoint = f"{self.base_stream_url}/accounts/{self.account_id}/pricing/stream?instruments={instruments}"
        
        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }

        logger.info(f"Starting Market Data Stream for: {instruments}")

        async with httpx.AsyncClient() as client:
            try:
                async with client.stream("GET", endpoint, headers=headers, timeout=None) as response:
                    if response.status_code != 200:
                        logger.error(f"Stream connection failed: {response.status_code}")
                        self.is_running = False
                        return

                    async for line in response.aiter_lines():
                        if not self.is_running:
                            break
                        
                        if line:
                            try:
                                data = json.loads(line)
                                if data.get("type") == "PRICE":
                                    await self._process_price_update(data)
                                elif data.get("type") == "HEARTBEAT":
                                    pass 
                            except Exception as e:
                                logger.error(f"Error parsing stream line: {e}")
            except Exception as e:
                logger.error(f"Stream connection error: {e}")
                self.is_running = False

    async def _process_price_update(self, data: Dict):
        symbol = data.get("instrument")
        if not symbol:
            return

        # Calculate mid price from bids and asks
        # Oanda stream returns list of bids/asks with liquidity
        try:
            bid = float(data["bids"][0]["price"])
            ask = float(data["asks"][0]["price"])
            mid_price = (bid + ask) / 2.0
            
            self.latest_prices[symbol] = mid_price
            
            # Notify subscribers
            for callback in self.subscribers:
                if asyncio.iscoroutinefunction(callback):
                    await callback(symbol, mid_price)
                else:
                    callback(symbol, mid_price)
        except (KeyError, IndexError, ValueError) as e:
            logger.warning(f"Malformed price data: {e}")

    def get_latest_price(self, symbol: str) -> float:
        return self.latest_prices.get(symbol, 0.0)

    async def get_snapshot(self, symbol: str) -> Dict[str, float]:
        """Returns a snapshot of the current price."""
        return {"price": self.get_latest_price(symbol)}

    async def get_historical_candles(self, symbol: str, count: int = 100, granularity: str = "M15") -> Dict[str, List[float]]:
        """
        Fetches historical candles for a symbol from Oanda API.
        """
        endpoint = f"{self.base_api_url}/instruments/{symbol}/candles"
        
        params = {
            "count": count,
            "granularity": granularity,
            "price": "M"
        }
        
        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }

        async with httpx.AsyncClient() as client:
            try:
                response = await client.get(endpoint, headers=headers, params=params, timeout=10.0)
                
                if response.status_code != 200:
                    logger.error(f"Failed to fetch candles: {response.text}")
                    return {}
                
                data = response.json()
                candles = data.get("candles", [])
                
                result = {"high": [], "low": [], "close": []}
                
                for candle in candles:
                    if candle["complete"]:
                        mid = candle["mid"]
                        result["high"].append(float(mid["h"]))
                        result["low"].append(float(mid["l"]))
                        result["close"].append(float(mid["c"]))
                        
                return result
            except Exception as e:
                logger.error(f"Error fetching historical candles: {e}")
                return {}

    def stop(self):
        self.is_running = False
        logger.info("Stopping Market Data Stream...")

    def subscribe(self, callback: Callable):
        """Add a callback function to be called on price updates."""
        self.subscribers.append(callback)