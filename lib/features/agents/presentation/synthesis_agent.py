import google.generativeai as genai
from agents.base_agent import BaseAgent
from core.config import settings
from core.logger import logger
import json
from typing import Dict, Any

class SynthesisAgent(BaseAgent):
    def __init__(self):
        super().__init__(name="The Council (Synthesis)", role="Final Decision Maker")
        genai.configure(api_key=settings.GEMINI_API_KEY)
        # Using gemini-1.5-pro for complex reasoning and synthesis capabilities
        self.model = genai.GenerativeModel('gemini-1.5-pro')

    async def analyze(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """
        Aggregates reports from other agents to make a final trading decision.
        
        Context expects:
        {
            'symbol': 'EURUSD',
            'technical_analysis': {...},
            'sentiment_analysis': {...},
            'macro_analysis': {...},
            'risk_analysis': {...}
        }
        """
        logger.info(f"Synthesis Agent aggregating decisions for {context.get('symbol')}")
        
        # Extract reports safely
        tech_report = context.get('technical_analysis', {})
        sentiment_report = context.get('sentiment_analysis', {})
        macro_report = context.get('macro_analysis', {})
        risk_report = context.get('risk_analysis', {})
        
        prompt = f"""
        You are the Head Trader and Portfolio Manager of an autonomous Forex trading firm.
        You have received reports from your specialized agents. Your job is to synthesize their findings and make a final trading decision.

        Market Context:
        Symbol: {context.get('symbol')}
        
        Report 1: Technical Analyst (Chart Patterns & Indicators)
        {json.dumps(tech_report, indent=2)}
        
        Report 2: Fundamentalist (News & Sentiment)
        {json.dumps(sentiment_report, indent=2)}
        
        Report 3: Macro Economist (Economic Events)
        {json.dumps(macro_report, indent=2)}
        
        Report 4: Risk Manager (Safety & Position Sizing)
        {json.dumps(risk_report, indent=2)}
        
        Task:
        1. Evaluate the consensus. Do the agents agree?
        2. Weigh the evidence. Technicals might signal a buy, but if Risk says "Spread too high" or "Daily loss limit reached", you must HOLD.
        3. If Technicals and Fundamentals/Macro conflict, prioritize Risk first, then the stronger signal with higher confidence.
        
        Output your final decision in strict JSON format with this schema:
        {{
            "action": "EXECUTE_BUY" | "EXECUTE_SELL" | "HOLD",
            "confidence": <float between 0.0 and 1.0>,
            "reasoning": "<executive summary of why this decision was made>",
            "risk_approved": <boolean>,
            "final_stop_loss": <price or null>,
            "final_take_profit": <price or null>
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
            logger.error(f"Synthesis analysis failed: {e}")
            return {
                "action": "HOLD",
                "confidence": 0.0,
                "reasoning": f"Synthesis failed: {str(e)}",
                "risk_approved": False,
                "final_stop_loss": None,
                "final_take_profit": None
            }