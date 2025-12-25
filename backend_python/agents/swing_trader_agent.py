# backend_python/agents/swing_trader_agent.py
# This agent implements a swing trading strategy, focusing on medium-term price swings.
from backend_python.agents.base_agent import BaseAgent
from backend_python.ai.decision_engine import DecisionEngine

class SwingTraderAgent(BaseAgent):
    def __init__(self, agent_id: str, decision_engine: DecisionEngine):
        super().__init__(agent_id, decision_engine)
        self.agent_profile["risk_tolerance"] = "medium"
        self.agent_profile["strategy"] = "swing_trading"

    async def make_decision(self, market_data: dict) -> dict:
        print(f"Swing Trader Agent {self.agent_id} analyzing market data for swings: {market_data}")
        # AI-driven decision
        ai_decision = await self.decision_engine.make_trading_decision(
            market_data, self.agent_profile
        )

        # Overlay with swing trading rules (example: looking for reversals or continuations)
        # This is a placeholder for actual swing trading logic
        if ai_decision["decision"] == "HOLD":
            if market_data.get("RSI", 50) < 30 and market_data.get("stochastic_oscillator", 50) < 20:
                ai_decision["decision"] = "BUY"
                ai_decision["reason"] += " (Swing rule: Oversold conditions, potential reversal up.)"
            elif market_data.get("RSI", 50) > 70 and market_data.get("stochastic_oscillator", 50) > 80:
                ai_decision["decision"] = "SELL"
                ai_decision["reason"] += " (Swing rule: Overbought conditions, potential reversal down.)"
        
        return ai_decision
