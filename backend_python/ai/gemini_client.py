# backend_python/ai/gemini_client.py
# This file integrates with the Google Gemini API.
# User needs to install 'google-generativeai' SDK: pip install google-generativeai
import os
import google.generativeai as genai
from decouple import config

class GeminiAIClient:
    def __init__(self):
        gemini_api_key = config("GEMINI_API_KEY", default="AIzaSyBRrf3oC4E0p9SgjLJg78AFfdWtRgVyqvE") # Using provided key
        genai.configure(api_key=gemini_api_key)
        self.model = genai.GenerativeModel('gemini-pro')
        print("GeminiAIClient initialized.")

    async def get_decision(self, prompt: str):
        print(f"Gemini AI processing prompt: {prompt}")
        try:
            response = self.model.generate_content(prompt)
            return response.text
        except Exception as e:
            print(f"Error calling Gemini API: {e}")
            return f"AI Decision for '{prompt}': Error - {e}"
