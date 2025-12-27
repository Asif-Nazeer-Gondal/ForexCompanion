import google.generativeai as genai
from agents.base_agent import BaseAgent
from core.config import settings
from core.logger import logger
import json
from typing import Dict, Any

class MacroAgent(BaseAgent):
    def __init__(self):
        super().__init__(name="Macro Economist", role="Economic Event Analysis")
        genai.configure(api_key=settings.GEMINI_API_KEY)
        # Using gemini-1.5-flash for efficient processing of structured text
        self.model = genai.GenerativeModel('gemini-1.5-flash')

    async def analyze(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Analyzes economic calendar events to determine macro sentiment.
        
        Context expects:
        {
            'symbol': 'EURUSD',
            'events': [
                {
                    "title": "Non-Farm Payrolls",
                    "currency": "USD",
                    "impact": "HIGH",
                    "actual": "250K",
                    "forecast": "180K",
                    "previous": "150K"
                },
                ...
            ]
        }
        """
        logger.info(f"Macro Agent analyzing {context.get('symbol')}")
        
        events = context.get('events', [])
        if not events:
            return {
                "signal": "NEUTRAL",
                "confidence": 0.0,
                "reasoning": "No economic events provided for analysis.",
                "key_factors": []
            }

        prompt = f"""
        You are an expert Macro Economist for Forex markets.
        
        Market Context:
        Symbol: {context.get('symbol')}
        
        Recent/Upcoming Economic Events:
        {json.dumps(events, indent=2)}
        
        Task:
        1. Analyze the impact of these economic data points on the {context.get('symbol')} pair.
        2. Consider the deviation between 'actual' and 'forecast' figures.
        3. Determine if the macro environment is Bullish (positive for base/negative for quote), Bearish, or Neutral.
        
        Return your response in strict JSON format with this schema:
        {{
            "signal": "BULLISH" | "BEARISH" | "NEUTRAL",
            "confidence": <float between 0.0 and 1.0>,
            "reasoning": "<concise explanation of macro drivers>",
            "key_factors": ["<list of most impactful data points>"]
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
            logger.error(f"Macro analysis failed: {e}")
            return {
                "signal": "NEUTRAL",
                "confidence": 0.0,
                "reasoning": f"Analysis failed: {str(e)}",
                "key_factors": []
            }