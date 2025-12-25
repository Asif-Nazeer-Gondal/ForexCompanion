# backend_python/risk/circuit_breaker.py
# This file will implement a circuit breaker (kill switch) for trading.
# For now, it's a placeholder.
class CircuitBreaker:
    def __init__(self):
        self.is_tripped = False

    def trip(self):
        self.is_tripped = True
        print("Circuit breaker tripped! All trading halted.")

    def reset(self):
        self.is_tripped = False
        print("Circuit breaker reset. Trading can resume.")

    def check(self):
        return self.is_tripped
