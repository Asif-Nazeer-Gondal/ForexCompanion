# backend_python/agents/base_agent.py
# This file defines the base class for all trading agents.
from abc import ABC, abstractmethod
from backend_python.ai.decision_engine import DecisionEngine

class BaseAgent(ABC):
    def __init__(self, agent_id: str, decision_engine: DecisionEngine):
        self.agent_id = agent_id
        self.decision_engine = decision_engine
        self.is_active = False
        self.agent_profile = {"risk_tolerance": "medium"} # Example profile

    @abstractmethod
    async def make_decision(self, market_data: dict) -> dict:
        pass

    def start(self):
        self.is_active = True
        print(f"Agent {self.agent_id} started.")

    def stop(self):
        self.is_active = False
        print(f"Agent {self.agent_id} stopped.")