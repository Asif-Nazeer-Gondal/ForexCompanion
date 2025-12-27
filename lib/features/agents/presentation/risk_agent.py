from agents.base_agent import BaseAgent
from strategies.guardrails import Guardrails, RiskException
from core.logger import logger
from typing import Dict, Any

class RiskAgent(BaseAgent):
    def __init__(self):
        super().__init__(name="Risk Manager", role="Safety & Position Sizing")
        self.guardrails = Guardrails()

    async def analyze(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Validates trade safety using hard-coded guardrails.
        
        Context expects:
        {
            'symbol': 'EURUSD',
            'spread': 1.2,
            'account_equity': 10000.0,
            'current_drawdown': 0.5, # Percent
        }
        """
        logger.info(f"Risk Agent analyzing {context.get('symbol')}")
        
        symbol = context.get('symbol')
        spread = context.get('spread', 0.0)
        equity = context.get('account_equity', 0.0)
        drawdown = context.get('current_drawdown', 0.0)

        report = {
            "approved": False,
            "confidence": 1.0, # Deterministic checks have high confidence
            "reasoning": "",
            "checks": [],
            "metrics": {
                "spread": spread,
                "equity": equity,
                "daily_drawdown": drawdown
            }
        }

        try:
            self.guardrails.check_trade(
                symbol=symbol,
                spread=spread,
                account_equity=equity,
                current_drawdown=drawdown
            )
            report["approved"] = True
            report["reasoning"] = "All safety checks passed."
            report["checks"].append("Spread within limits")
            report["checks"].append("Drawdown within limits")
            
        except RiskException as e:
            report["approved"] = False
            report["reasoning"] = f"Safety violation: {str(e)}"
            report["checks"].append(f"FAILED: {str(e)}")
            logger.warning(f"Risk Agent vetoed trade: {e}")

        return report