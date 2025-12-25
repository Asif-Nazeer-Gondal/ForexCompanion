# backend_python/cache/redis_client.py
# This file will contain the Redis client setup and basic cache operations.
# For now, it's a placeholder.
import redis

class RedisClient:
    def __init__(self, host='localhost', port=6379, db=0):
        self.client = redis.StrictRedis(host=host, port=port, db=db, decode_responses=True)

    def get(self, key):
        return self.client.get(key)

    def set(self, key, value, ex=None, px=None, nx=False, xx=False):
        return self.client.set(key, value, ex=ex, px=px, nx=nx, xx=xx)

    def delete(self, key):
        return self.client.delete(key)
