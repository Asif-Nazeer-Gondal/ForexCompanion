# backend_python/routers/agents.py
from fastapi import APIRouter, Depends, HTTPException, Request
from backend_python.agents.agent_manager import AgentManager
from backend_python.ai.decision_engine import DecisionEngine
from backend_python.ai.claude_client import ClaudeAIClient

router = APIRouter()

# Dependency to get the AgentManager instance
def get_agent_manager(request: Request) -> AgentManager:
    # Ensure AI client is initialized (from main.py startup event)
    ai_client = request.app.state.ai_client
    decision_engine = DecisionEngine(ai_client)
    return AgentManager(decision_engine)

@router.post("/agents/{agent_id}/start")
async def start_agent(agent_id: str, agent_manager: AgentManager = Depends(get_agent_manager)):
    agent = agent_manager.get_agent(agent_id)
    if not agent:
        raise HTTPException(status_code=404, detail="Agent not found")
    await agent_manager.start_agent(agent_id)
    return {"status": "started", "agent_id": agent_id}

@router.post("/agents/{agent_id}/stop")
async def stop_agent(agent_id: str, agent_manager: AgentManager = Depends(get_agent_manager)):
    agent = agent_manager.get_agent(agent_id)
    if not agent:
        raise HTTPException(status_code=404, detail="Agent not found")
    await agent_manager.stop_agent(agent_id)
    return {"status": "stopped", "agent_id": agent_id}

@router.post("/agents/{agent_id}/decision")
async def get_agent_decision(
    agent_id: str,
    market_data: dict,
    agent_manager: AgentManager = Depends(get_agent_manager)
):
    agent = agent_manager.get_agent(agent_id)
    if not agent:
        raise HTTPException(status_code=404, detail="Agent not found")
    if not agent.is_active:
        raise HTTPException(status_code=400, detail="Agent is not active")
    
    decision = await agent_manager.trigger_agent_decision(agent_id, market_data)
    return {"agent_id": agent_id, "decision": decision}

@router.get("/agents")
async def list_agents(agent_manager: AgentManager = Depends(get_agent_manager)):
    return {"agents": list(agent_manager.agents.keys())}
