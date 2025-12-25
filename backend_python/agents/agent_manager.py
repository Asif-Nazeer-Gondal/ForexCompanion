# backend_python/agents/agent_manager.py
# This file manages the lifecycle and orchestration of trading agents.
from typing import Dict
from backend_python.agents.base_agent import BaseAgent
from backend_python.agents.conservative_agent import ConservativeAgent
from backend_python.agents.aggressive_agent import AggressiveAgent
from backend_python.ai.decision_engine import DecisionEngine

class AgentManager:
    def __init__(self, decision_engine: DecisionEngine):
        self.agents: Dict[str, BaseAgent] = {}
        self.decision_engine = decision_engine
        
        # Example: Registering some agents
        self.register_agent(ConservativeAgent("con_agent_1", self.decision_engine))
        self.register_agent(AggressiveAgent("agg_agent_1", self.decision_engine))

    def register_agent(self, agent: BaseAgent):
        if agent.agent_id in self.agents:
            print(f"Agent {agent.agent_id} already registered. Overwriting.")
        self.agents[agent.agent_id] = agent

    def get_agent(self, agent_id: str) -> BaseAgent:
        return self.agents.get(agent_id)

    async def start_agent(self, agent_id: str):
        agent = self.get_agent(agent_id)
        if agent:
            agent.start()
            # In a real system, you'd start a separate task/thread for the agent
            # to continuously make decisions. For now, it just changes status.
            print(f"Agent {agent_id} is now active.")
        else:
            print(f"Agent {agent_id} not found.")

    async def stop_agent(self, agent_id: str):
        agent = self.get_agent(agent_id)
        if agent:
            agent.stop()
            print(f"Agent {agent_id} is now inactive.")
        else:
            print(f"Agent {agent_id} not found.")

    async def trigger_agent_decision(self, agent_id: str, market_data: dict):
        agent = self.get_agent(agent_id)
        if agent and agent.is_active:
            decision = await agent.make_decision(market_data)
            print(f"Agent {agent_id} made decision: {decision}")
            return decision
        elif not agent:
            return {"status": "error", "message": f"Agent {agent_id} not found."}
        else:
            return {"status": "error", "message": f"Agent {agent_id} is not active."}
