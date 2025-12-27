import asyncio
import httpx
from core.config import settings
from core.logger import logger
from typing import Dict, Optional, Any

class OrderManager:
    def __init__(self):
        self.api_key = settings.BROKER_API_KEY
        self.account_id = settings.BROKER_ACCOUNT_ID
        # Defaulting to Oanda demo environment for safety
        self.base_url = "https://api-fxpractice.oanda.com/v3"
        if settings.ENV == "production":
             self.base_url = "https://api-fxtrade.oanda.com/v3"

    def _get_headers(self) -> Dict[str, str]:
        return {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
            "Accept-Datetime-Format": "RFC3339"
        }

    async def _request(self, method: str, endpoint: str, **kwargs) -> httpx.Response:
        max_retries = 3
        backoff_factor = 2.0
        
        for attempt in range(max_retries):
            async with httpx.AsyncClient() as client:
                try:
                    response = await client.request(
                        method, 
                        endpoint, 
                        headers=self._get_headers(),
                        timeout=10.0,
                        **kwargs
                    )
                    
                    if response.status_code >= 500 or response.status_code == 429:
                        if attempt < max_retries - 1:
                            delay = backoff_factor ** attempt
                            logger.warning(f"Request failed with status {response.status_code}. Retrying in {delay}s...")
                            await asyncio.sleep(delay)
                            continue
                    
                    return response

                except httpx.RequestError as e:
                    if attempt < max_retries - 1:
                        delay = backoff_factor ** attempt
                        logger.warning(f"Network error: {e}. Retrying in {delay}s...")
                        await asyncio.sleep(delay)
                    else:
                        raise e
        raise httpx.RequestError("Max retries exceeded")

    async def place_market_order(
        self, 
        symbol: str, 
        units: int, 
        stop_loss: Optional[float] = None, 
        take_profit: Optional[float] = None
    ) -> Dict[str, Any]:
        """
        Executes a market order immediately.
        Positive units = BUY, Negative units = SELL.
        """
        endpoint = f"{self.base_url}/accounts/{self.account_id}/orders"
        
        # Oanda Order Payload
        order_data = {
            "order": {
                "units": str(units),
                "instrument": symbol,
                "timeInForce": "FOK", # Fill or Kill
                "type": "MARKET",
                "positionFill": "DEFAULT"
            }
        }

        if stop_loss:
            order_data["order"]["stopLossOnFill"] = {
                "price": f"{stop_loss:.5f}",
                "timeInForce": "GTC" # Good Till Cancelled
            }
        
        if take_profit:
            order_data["order"]["takeProfitOnFill"] = {
                "price": f"{take_profit:.5f}",
                "timeInForce": "GTC"
            }

        logger.info(f"🚀 Placing Market Order: {symbol} | Units: {units}")
        
        try:
            response = await self._request("POST", endpoint, json=order_data)
            
            if response.status_code != 201:
                logger.error(f"Order failed: {response.text}")
                return {"status": "failed", "error": response.text}
            
            data = response.json()
            logger.info(f"Order Executed: {data.get('orderFillTransaction', {}).get('id')}")
            return {"status": "filled", "data": data}
            
        except Exception as e:
            logger.error(f"Exception during order placement: {e}")
            return {"status": "error", "error": str(e)}

    async def close_position(self, symbol: str, long: bool = True) -> Dict[str, Any]:
        """
        Closes an existing position for a symbol.
        long: True to close long position, False to close short.
        """
        endpoint = f"{self.base_url}/accounts/{self.account_id}/positions/{symbol}/close"
        
        payload = {}
        if long:
            payload["longUnits"] = "ALL"
        else:
            payload["shortUnits"] = "ALL"

        logger.info(f"Closing {'Long' if long else 'Short'} position for {symbol}")

        try:
            response = await self._request("PUT", endpoint, json=payload)
            
            if response.status_code != 200:
                logger.error(f"Close position failed: {response.text}")
                return {"status": "failed", "error": response.text}
                
            return {"status": "closed", "data": response.json()}
        except Exception as e:
            logger.error(f"Exception closing position: {e}")
            return {"status": "error", "error": str(e)}

    async def get_account_summary(self) -> Dict[str, Any]:
        """Fetches account balance, equity, and margin."""
        endpoint = f"{self.base_url}/accounts/{self.account_id}/summary"
        
        try:
            response = await self._request("GET", endpoint, timeout=5.0)
            return response.json()
        except Exception as e:
            logger.error(f"Failed to fetch account summary: {e}")
            return {}

    async def get_open_trades(self) -> list[Dict[str, Any]]:
        """Fetches all open trades for the account."""
        endpoint = f"{self.base_url}/accounts/{self.account_id}/openTrades"
        try:
            response = await self._request("GET", endpoint)
            return response.json().get("trades", [])
        except Exception as e:
            logger.error(f"Failed to fetch open trades: {e}")
            return []

    async def modify_trade(self, symbol: str, stop_loss: Optional[float], take_profit: Optional[float]) -> Dict[str, Any]:
        """
        Modifies the Stop Loss and Take Profit for the first open trade of a symbol.
        """
        # 1. Find the trade ID for the symbol
        trades = await self.get_open_trades()
        target_trade = next((t for t in trades if t["instrument"] == symbol), None)
        
        if not target_trade:
            return {"status": "failed", "error": "Trade not found"}

        trade_id = target_trade["id"]
        endpoint = f"{self.base_url}/accounts/{self.account_id}/trades/{trade_id}/orders"
        
        payload = {}
        if stop_loss is not None:
            payload["stopLoss"] = {
                "price": f"{stop_loss:.5f}",
                "timeInForce": "GTC"
            }
        
        if take_profit is not None:
            payload["takeProfit"] = {
                "price": f"{take_profit:.5f}",
                "timeInForce": "GTC"
            }

        logger.info(f"Modifying trade {trade_id} for {symbol}: SL={stop_loss}, TP={take_profit}")

        try:
            response = await self._request("PUT", endpoint, json=payload)
            return {"status": "modified", "data": response.json()}
        except Exception as e:
            logger.error(f"Exception modifying trade: {e}")
            return {"status": "error", "error": str(e)}