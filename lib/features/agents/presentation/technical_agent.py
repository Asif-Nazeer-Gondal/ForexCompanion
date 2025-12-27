import google.generativeai as genai
from agents.base_agent import BaseAgent
from core.config import settings
from core.logger import logger
import json
from typing import Dict, Any

class TechnicalAgent(BaseAgent):
    def __init__(self):
        super().__init__(name="Technical Analyst", role="Chart Pattern Analysis")
        genai.configure(api_key=settings.GEMINI_API_KEY)
        # Using gemini-1.5-flash for speed and JSON capabilities
        self.model = genai.GenerativeModel('gemini-1.5-flash')

    async def analyze(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Context expects: {'symbol': 'EURUSD', 'indicators': {'rsi': 30, 'macd': ...}, 'price': ...}
        """
        logger.info(f"Technical Agent analyzing {context.get('symbol')}")
        
        prompt = f"""
        You are an expert Technical Analyst for Forex markets.
        
        Market Context:
        Symbol: {context.get('symbol')}
        Current Price: {context.get('price')}
        Indicators: {context.get('indicators')}
        
        Analyze the technical indicators provided.
        1. Identify the trend direction.
        2. Check for momentum conditions (Overbought/Oversold).
        3. Look for any potential divergences or confirmation signals.
        
        Determine a trading signal based on this data.
        
        Return your response in strict JSON format with this schema:
        {{
            "signal": "BUY" | "SELL" | "NEUTRAL",
            "confidence": <float between 0.0 and 1.0>,
            "reasoning": "<concise explanation>",
            "suggested_stop_loss": <price or null>,
            "suggested_take_profit": <price or null>
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
            logger.error(f"Gemini analysis failed: {e}")
            return {
                "signal": "NEUTRAL", 
                "confidence": 0.0, 
                "reasoning": f"Analysis failed: {str(e)}",
                "suggested_stop_loss": None,
                "suggested_take_profit": None
            }