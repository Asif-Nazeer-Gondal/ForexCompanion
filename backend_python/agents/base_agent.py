from sqlalchemy.orm import Session
from backend_python.database.models.agent_state import AgentState

class BaseAgent:
    def __init__(self, user_id: int, agent_name: str, db_session: Session):
        self.user_id = user_id
        self.agent_name = agent_name
        self.db_session = db_session
        self.state = {}
        self.load_state()

    def load_state(self):
        """Loads the agent's state from the database."""
        agent_state = self.db_session.query(AgentState).filter_by(
            user_id=self.user_id,
            agent_name=self.agent_name
        ).first()
        if agent_state:
            self.state = agent_state.state
            print(f"Agent '{self.agent_name}' loaded state: {self.state}")
        else:
            print(f"No state found for agent '{self.agent_name}'. Initializing with empty state.")
            self.state = {"initialized": True}
            self.save_state()

    def save_state(self):
        """Saves the agent's state to the database."""
        agent_state = self.db_session.query(AgentState).filter_by(
            user_id=self.user_id,
            agent_name=self.agent_name
        ).first()
        if agent_state:
            agent_state.state = self.state
        else:
            agent_state = AgentState(
                user_id=self.user_id,
                agent_name=self.agent_name,
                state=self.state
            )
            self.db_session.add(agent_state)
        
        self.db_session.commit()
        print(f"Agent '{self.agent_name}' saved state: {self.state}")

    def run(self):
        """A simple run method to demonstrate agent logic."""
        print(f"Agent '{self.agent_name}' is running with state: {self.state}")
        # Example logic: increment a counter in the state
        count = self.state.get("run_count", 0) + 1
        self.state["run_count"] = count
        self.save_state()
