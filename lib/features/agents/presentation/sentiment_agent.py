import google.generativeai as genai
from agents.base_agent import BaseAgent
from core.config import settings
from core.logger import logger
import json
from typing import Dict, Any

class SentimentAgent(BaseAgent):
    def __init__(self):
        super().__init__(name="Fundamentalist", role="News & Sentiment Analysis")
        genai.configure(api_key=settings.GEMINI_API_KEY)
        # Using gemini-1.5-flash for efficient text processing
        self.model = genai.GenerativeModel('gemini-1.5-flash')

    async def analyze(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Analyzes news headlines to determine market sentiment.
        
        Context expects:
        {
            'symbol': 'EURUSD',
            'headlines': [
                "ECB likely to hike rates...",
                "US inflation data comes in lower than expected..."
            ]
        }
        """
        logger.info(f"Sentiment Agent analyzing {context.get('symbol')}")
        
        headlines = context.get('headlines', [])
        if not headlines:
            return {
                "signal": "NEUTRAL",
                "confidence": 0.0,
                "reasoning": "No headlines provided for analysis.",
                "key_events": []
            }

        prompt = f"""
        You are an expert Fundamental Analyst for Forex markets.
        
        Market Context:
        Symbol: {context.get('symbol')}
        
        Recent News Headlines:
        {json.dumps(headlines, indent=2)}
        
        Task:
        1. Analyze the sentiment of these headlines specifically for the {context.get('symbol')} pair.
        2. Determine if the news is Bullish (positive for base currency/negative for quote), Bearish, or Neutral.
        3. Assess the impact level of these events.
        
        Return your response in strict JSON format with this schema:
        {{
            "signal": "BULLISH" | "BEARISH" | "NEUTRAL",
            "confidence": <float between 0.0 and 1.0>,
            "reasoning": "<concise explanation of key drivers>",
            "key_events": ["<list of most impactful headlines>"]
        }}
        """

        try:
            # Enforce JSON response type for reliability
            response = self.model.generate_content(
                prompt,
                generation_config={"response_mime_type": "application/json"}
            )
            result = json.loads(response.text)
            return result
        except Exception as e:
            logger.error(f"Sentiment analysis failed: {e}")
            return {
                "signal": "NEUTRAL",
                "confidence": 0.0,
                "reasoning": f"Analysis failed: {str(e)}",
                "key_events": []
            }