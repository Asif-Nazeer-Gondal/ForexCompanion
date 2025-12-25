# backend_python/agents/memory/context_manager.py
# This file will manage the contextual information for agents.
# For now, it's a placeholder.
class ContextManager:
    def __init__(self):
        self._context = {}

    def set_context(self, key, value):
        self._context[key] = value

    def get_context(self, key):
        return self._context.get(key)
