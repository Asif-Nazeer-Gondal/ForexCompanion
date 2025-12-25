# backend_python/agents/aggressive_agent.py
# This agent implements an aggressive trading strategy.
from backend_python.agents.base_agent import BaseAgent
from backend_python.ai.decision_engine import DecisionEngine

class AggressiveAgent(BaseAgent):
    def __init__(self, agent_id: str, decision_engine: DecisionEngine):
        super().__init__(agent_id, decision_engine)
        self.agent_profile["risk_tolerance"] = "high"
        self.agent_profile["strategy"] = "aggressive"

    async def make_decision(self, market_data: dict) -> dict:
        print(f"Aggressive Agent {self.agent_id} analyzing market data: {market_data}")
        # AI-driven decision
        ai_decision = await self.decision_engine.make_trading_decision(
            market_data, self.agent_profile
        )

        # Overlay with aggressive rules:
        if ai_decision["decision"] == "HOLD" and market_data.get("momentum", 0) > 0.01:
            ai_decision["decision"] = "BUY"
            ai_decision["reason"] += " (Aggressive rule: Strong momentum, buying.)"
        
        if ai_decision["decision"] == "HOLD" and market_data.get("momentum", 0) < -0.01:
            ai_decision["decision"] = "SELL"
            ai_decision["reason"] += " (Aggressive rule: Strong negative momentum, selling.)"

        return ai_decision
