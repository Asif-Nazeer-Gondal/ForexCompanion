import unittest
import sys
import os

# Add parent directory to path to allow importing modules from the presentation layer
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from technical_analysis_service import TechnicalAnalysisService

class TestTechnicalAnalysisService(unittest.TestCase):
    def setUp(self):
        self.service = TechnicalAnalysisService()

    def test_analyze_candles_insufficient_data(self):
        # Create data with fewer than 30 candles
        candles = {
            'high': [1.0] * 10,
            'low': [1.0] * 10,
            'close': [1.0] * 10
        }
        result = self.service.analyze_candles(candles)
        self.assertEqual(result, {})

    def test_analyze_candles_sufficient_data(self):
        # Generate synthetic data (100 candles)
        # Simple uptrend: Price increases by 1.0 each step
        count = 100
        close = [100.0 + i for i in range(count)]
        high = [c + 1.0 for c in close]
        low = [c - 1.0 for c in close]
        
        candles = {
            'high': high,
            'low': low,
            'close': close
        }

        result = self.service.analyze_candles(candles)

        # Verify keys exist
        expected_keys = ['rsi', 'macd', 'bbands', 'ema_50', 'atr']
        for key in expected_keys:
            self.assertIn(key, result)
        
        # EMA 200 should be None (not enough data, need >= 200)
        self.assertIsNone(result.get('ema_200'))

        # Verify MACD structure
        self.assertIn('line', result['macd'])
        self.assertIn('signal', result['macd'])
        self.assertIn('histogram', result['macd'])

        # Verify Bollinger Bands structure
        self.assertIn('upper', result['bbands'])
        self.assertIn('middle', result['bbands'])
        self.assertIn('lower', result['bbands'])

        # Sanity check values
        # RSI of a constant uptrend is typically high (> 70)
        self.assertGreater(result['rsi'], 70)
        
        # Middle band should be close to moving average (close to price)
        # Using delta because calculation methods vary slightly
        self.assertAlmostEqual(result['bbands']['middle'], close[-1], delta=5.0)

    def test_analyze_candles_ema200(self):
        # Generate enough data for EMA 200
        count = 250
        close = [100.0] * count # Flat line
        high = [101.0] * count
        low = [99.0] * count
        
        candles = {
            'high': high,
            'low': low,
            'close': close
        }

        result = self.service.analyze_candles(candles)
        
        # EMA 200 should be present
        self.assertIsNotNone(result.get('ema_200'))
        # EMA of a flat line is the value itself
        self.assertAlmostEqual(result['ema_200'], 100.0)

if __name__ == '__main__':
    unittest.main()