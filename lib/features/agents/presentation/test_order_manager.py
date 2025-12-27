import unittest
from unittest.mock import MagicMock, patch, AsyncMock
import sys
import os

# Add parent directory to path to allow importing modules from the presentation layer
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from order_manager import OrderManager

class TestOrderManager(unittest.IsolatedAsyncioTestCase):
    @patch('order_manager.settings')
    def setUp(self, mock_settings):
        mock_settings.BROKER_API_KEY = 'test_key'
        mock_settings.BROKER_ACCOUNT_ID = 'test_account'
        mock_settings.ENV = 'development'
        self.manager = OrderManager()

    async def test_close_position_long_success(self):
        # Arrange
        symbol = "EUR_USD"
        expected_response = {"longOrderFillTransaction": {"id": "123"}}
        
        mock_response = MagicMock()
        mock_response.status_code = 200
        mock_response.json.return_value = expected_response
        
        # Mock the _request method to avoid actual network calls
        self.manager._request = AsyncMock(return_value=mock_response)

        # Act
        result = await self.manager.close_position(symbol, long=True)

        # Assert
        self.assertEqual(result['status'], 'closed')
        self.assertEqual(result['data'], expected_response)
        
        self.manager._request.assert_called_once()
        args, kwargs = self.manager._request.call_args
        self.assertEqual(args[0], "PUT")
        self.assertIn(f"/positions/{symbol}/close", args[1])
        self.assertEqual(kwargs['json'], {"longUnits": "ALL"})

    async def test_close_position_short_success(self):
        # Arrange
        symbol = "EUR_USD"
        expected_response = {"shortOrderFillTransaction": {"id": "124"}}
        
        mock_response = MagicMock()
        mock_response.status_code = 200
        mock_response.json.return_value = expected_response
        
        self.manager._request = AsyncMock(return_value=mock_response)

        # Act
        result = await self.manager.close_position(symbol, long=False)

        # Assert
        self.assertEqual(result['status'], 'closed')
        self.assertEqual(result['data'], expected_response)
        self.assertEqual(self.manager._request.call_args[1]['json'], {"shortUnits": "ALL"})

    async def test_close_position_failure(self):
        # Arrange
        mock_response = MagicMock()
        mock_response.status_code = 400
        mock_response.text = "Invalid position"
        
        self.manager._request = AsyncMock(return_value=mock_response)

        # Act
        result = await self.manager.close_position("EUR_USD")

        # Assert
        self.assertEqual(result['status'], 'failed')
        self.assertEqual(result['error'], "Invalid position")

    async def test_close_position_exception(self):
        # Arrange
        self.manager._request = AsyncMock(side_effect=Exception("Network error"))

        # Act
        result = await self.manager.close_position("EUR_USD")

        # Assert
        self.assertEqual(result['status'], 'error')
        self.assertIn("Network error", result['error'])

if __name__ == '__main__':
    unittest.main()