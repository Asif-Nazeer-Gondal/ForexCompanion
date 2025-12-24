# backend_python/auth/jwt_handler.py
import time
from typing import Dict, Any

import jwt
from decouple import config

# For MVP, we use a hardcoded secret.
# In production, this should be loaded from a secure source like environment variables or a secret manager.
JWT_SECRET = config("secret_key", default="a_very_secret_key")
JWT_ALGORITHM = config("algorithm", default="HS256")


def token_response(token: str):
    return {"access_token": token}


def sign_jwt(user_id: str) -> Dict[str, Any]:
    """
    Sign a JWT for a given user ID.
    """
    payload = {
        "user_id": user_id,
        "expires": time.time() + 3600  # Token expires in 1 hour
    }
    token = jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)
    return token_response(token)


def decode_jwt(token: str) -> dict:
    """
    Decode a JWT.
    """
    try:
        decoded_token = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        return decoded_token if decoded_token["expires"] >= time.time() else None
    except:
        return {}

