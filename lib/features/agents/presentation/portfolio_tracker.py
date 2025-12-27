import asyncio
from typing import Dict, Any
from core.logger import logger
from domain.order_manager import OrderManager
from domain.market_data_feed import MarketDataFeed

class PortfolioTracker:
    def __init__(self, order_manager: OrderManager, market_data: MarketDataFeed):
        self.order_manager = order_manager
        self.market_data = market_data
        
        self.metrics = {
            "balance": 0.0,
            "equity": 0.0,
            "margin_used": 0.0,
            "free_margin": 0.0,
            "unrealized_pnl": 0.0,
            "margin_level": 0.0
        }

    async def update(self):
        """
        Fetches the latest account summary from the broker to update PnL and Margin.
        """
        try:
            summary = await self.order_manager.get_account_summary()
            if not summary or "account" not in summary:
                # Log warning but don't crash, maybe transient network issue
                return

            account = summary["account"]
            
            # Oanda V3 Account Summary fields
            self.metrics["balance"] = float(account.get("balance", 0.0))
            self.metrics["equity"] = float(account.get("NAV", 0.0)) # Net Asset Value
            self.metrics["margin_used"] = float(account.get("marginUsed", 0.0))
            self.metrics["free_margin"] = float(account.get("marginAvailable", 0.0))
            self.metrics["unrealized_pnl"] = float(account.get("unrealizedPL", 0.0))
            
            # Calculate Margin Level safely
            if self.metrics["margin_used"] > 0:
                self.metrics["margin_level"] = (self.metrics["equity"] / self.metrics["margin_used"]) * 100.0
            else:
                self.metrics["margin_level"] = 0.0 # Or infinite, 0 implies no risk

            # Fetch open trades to get SL/TP details
            trades = await self.order_manager.get_open_trades()
            self.metrics["open_positions"] = []
            for t in trades:
                sl = float(t["stopLossOrder"]["price"]) if "stopLossOrder" in t else None
                tp = float(t["takeProfitOrder"]["price"]) if "takeProfitOrder" in t else None
                
                self.metrics["open_positions"].append({
                    "symbol": t["instrument"],
                    "units": float(t["currentUnits"]),
                    "unrealized_pnl": float(t["unrealizedPL"]),
                    "stop_loss": sl,
                    "take_profit": tp
                })

            logger.info(f"Portfolio: Equity={self.metrics['equity']} | PnL={self.metrics['unrealized_pnl']}")

        except Exception as e:
            logger.error(f"Error updating portfolio metrics: {e}")

    def get_metrics(self) -> Dict[str, float]:
        return self.metrics