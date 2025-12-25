# backend_python/agents/memory/short_term_memory.py
# This file will store recent agent decisions and observations.
# For now, it's a placeholder.
class ShortTermMemory:
    def __init__(self, capacity=100):
        self._memory = []
        self._capacity = capacity

    def add(self, item):
        self._memory.append(item)
        if len(self._memory) > self._capacity:
            self._memory.pop(0)

    def get_recent(self, n):
        return self._memory[-n:]
