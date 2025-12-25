# backend_python/agents/conservative_agent.py
# This agent implements a conservative trading strategy.
from backend_python.agents.base_agent import BaseAgent
from backend_python.ai.decision_engine import DecisionEngine

class ConservativeAgent(BaseAgent):
    def __init__(self, agent_id: str, decision_engine: DecisionEngine):
        super().__init__(agent_id, decision_engine)
        self.agent_profile["risk_tolerance"] = "low"
        self.agent_profile["strategy"] = "conservative"

    async def make_decision(self, market_data: dict) -> dict:
        print(f"Conservative Agent {self.agent_id} analyzing market data: {market_data}")
        # AI-driven decision
        ai_decision = await self.decision_engine.make_trading_decision(
            market_data, self.agent_profile
        )
        
        # Overlay with conservative rules:
        if ai_decision["decision"] == "BUY" and market_data.get("volatility", 0) > 0.02:
            ai_decision["decision"] = "HOLD"
            ai_decision["reason"] += " (Conservative rule: High volatility, holding.)"
        
        if ai_decision["decision"] == "SELL" and market_data.get("price_change", 0) < -0.01:
            ai_decision["decision"] = "HOLD"
            ai_decision["reason"] += " (Conservative rule: Significant price drop, holding.)"

        return ai_decision
