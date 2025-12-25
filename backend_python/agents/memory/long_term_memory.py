# backend_python/agents/memory/long_term_memory.py
# This file will store historical patterns and learned knowledge.
# For now, it's a placeholder.
class LongTermMemory:
    def __init__(self):
        self._knowledge_base = {}

    def add_knowledge(self, key, value):
        self._knowledge_base[key] = value

    def get_knowledge(self, key):
        return self._knowledge_base.get(key)
