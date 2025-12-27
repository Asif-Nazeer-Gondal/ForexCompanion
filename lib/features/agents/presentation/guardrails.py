from core.logger import logger

class RiskException(Exception):
    pass

class Guardrails:
    def __init__(self):
        self.max_daily_loss_percent = 2.0
        self.max_spread_pips = 3.0
        self.blacklisted_hours = [22, 23] # Example: Avoid rollover hours

    def check_trade(self, symbol: str, spread: float, account_equity: float, current_drawdown: float):
        """
        Validates if a trade is safe to execute. Raises RiskException if unsafe.
        """
        logger.info(f"Running guardrails for {symbol}")

        # Rule 1: Spread Check
        if spread > self.max_spread_pips:
            raise RiskException(f"Spread too high: {spread} pips")

        # Rule 2: Daily Drawdown Limit
        if current_drawdown >= self.max_daily_loss_percent:
            raise RiskException(f"Daily loss limit reached: {current_drawdown}%")

        # Rule 3: News Events (Placeholder)
        # if self.is_high_impact_news_soon(symbol):
        #     raise RiskException("High impact news imminent")
        
        return True