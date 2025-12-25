# backend_python/agents/coordination/message_bus.py
# This file will contain the message bus for inter-agent communication.
# For now, it's a placeholder.
class MessageBus:
    def __init__(self):
        self._subscribers = {}

    def subscribe(self, topic, handler):
        if topic not in self._subscribers:
            self._subscribers[topic] = []
        self._subscribers[topic].append(handler)

    def publish(self, topic, message):
        if topic in self._subscribers:
            for handler in self._subscribers[topic]:
                handler(message)
