import unittest
from unittest.mock import MagicMock, patch
import json
import sys
import os

# Add parent directory to path to allow importing modules from the presentation layer
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from macro_agent import MacroAgent

class TestMacroAgent(unittest.IsolatedAsyncioTestCase):
    @patch('macro_agent.genai')
    @patch('macro_agent.settings')
    def setUp(self, mock_settings, mock_genai):
        # Setup mocks
        mock_settings.GEMINI_API_KEY = 'fake_api_key'
        
        # Instantiate agent
        # Note: This assumes BaseAgent and other dependencies are importable
        self.agent = MacroAgent()
        
        # The agent's model is instantiated in __init__, so we grab the mock that was returned
        self.mock_model = self.agent.model

    async def test_analyze_with_valid_events(self):
        # Arrange
        context = {
            'symbol': 'EURUSD',
            'events': [
                {
                    "title": "Non-Farm Payrolls",
                    "currency": "USD",
                    "impact": "HIGH",
                    "actual": "250K",
                    "forecast": "180K",
                    "previous": "150K"
                }
            ]
        }
        
        expected_response = {
            "signal": "BEARISH",
            "confidence": 0.9,
            "reasoning": "Strong NFP data indicates bullish USD, hence bearish EURUSD.",
            "key_factors": ["Non-Farm Payrolls actual 250K vs forecast 180K"]
        }
        
        # Mock the response from Gemini
        mock_response_obj = MagicMock()
        mock_response_obj.text = json.dumps(expected_response)
        self.mock_model.generate_content.return_value = mock_response_obj

        # Act
        result = await self.agent.analyze(context)

        # Assert
        self.assertEqual(result['signal'], "BEARISH")
        self.assertEqual(result['confidence'], 0.9)
        self.assertEqual(result['key_factors'], expected_response['key_factors'])
        
        # Verify the prompt contained the event data
        args, _ = self.mock_model.generate_content.call_args
        prompt_text = args[0]
        self.assertIn("Non-Farm Payrolls", prompt_text)
        self.assertIn("250K", prompt_text)

    async def test_analyze_with_no_events(self):
        # Arrange
        context = {
            'symbol': 'EURUSD',
            'events': []
        }

        # Act
        result = await self.agent.analyze(context)

        # Assert
        self.assertEqual(result['signal'], "NEUTRAL")
        self.assertEqual(result['confidence'], 0.0)
        self.assertIn("No economic events", result['reasoning'])
        
        # Ensure Gemini was NOT called
        self.mock_model.generate_content.assert_not_called()

    async def test_analyze_api_failure(self):
        # Arrange
        context = {
            'symbol': 'EURUSD',
            'events': [{"title": "Some Event"}]
        }
        
        # Simulate API exception
        self.mock_model.generate_content.side_effect = Exception("API Connection Error")

        # Act
        result = await self.agent.analyze(context)

        # Assert
        self.assertEqual(result['signal'], "NEUTRAL")
        self.assertEqual(result['confidence'], 0.0)
        self.assertIn("Analysis failed", result['reasoning'])

if __name__ == '__main__':
    unittest.main()