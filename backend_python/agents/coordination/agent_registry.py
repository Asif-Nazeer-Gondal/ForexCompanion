# backend_python/agents/coordination/agent_registry.py
# This file will contain the registry for active agents.
# For now, it's a placeholder.
class AgentRegistry:
    def __init__(self):
        self._agents = {}

    def register_agent(self, agent_id, agent_instance):
        self._agents[agent_id] = agent_instance

    def get_agent(self, agent_id):
        return self._agents.get(agent_id)

    def list_agents(self):
        return list(self._agents.keys())
