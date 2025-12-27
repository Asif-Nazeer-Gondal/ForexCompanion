import numpy as np
import talib
from typing import Dict, Any, List
from core.logger import logger

class TechnicalAnalysisService:
    def analyze_candles(self, candles: Dict[str, List[float]]) -> Dict[str, Any]:
        """
        Calculates technical indicators based on historical candle data.
        
        Args:
            candles: Dict containing lists of 'high', 'low', 'close' prices.
                     Expected keys: 'high', 'low', 'close'.
                     Lists should be ordered from oldest to newest.
        
        Returns:
            Dict containing calculated indicators.
        """
        try:
            # Convert inputs to numpy arrays (TA-Lib requires double precision numpy arrays)
            # Ensure we have enough data
            close = np.array(candles.get('close', []), dtype=np.double)
            
            if len(close) < 30:
                logger.warning(f"Not enough candle data for technical analysis. Count: {len(close)}")
                return {}

            high = np.array(candles.get('high', []), dtype=np.double)
            low = np.array(candles.get('low', []), dtype=np.double)

            indicators = {}

            # 1. RSI (Relative Strength Index) - Momentum
            # Standard period 14
            rsi = talib.RSI(close, timeperiod=14)
            indicators['rsi'] = rsi[-1]

            # 2. MACD (Moving Average Convergence Divergence) - Trend/Momentum
            macd, macd_signal, macd_hist = talib.MACD(close, fastperiod=12, slowperiod=26, signalperiod=9)
            indicators['macd'] = {
                "line": macd[-1],
                "signal": macd_signal[-1],
                "histogram": macd_hist[-1]
            }

            # 3. Bollinger Bands - Volatility
            upper, middle, lower = talib.BBANDS(close, timeperiod=20, nbdevup=2, nbdevdn=2, matype=0)
            indicators['bbands'] = {
                "upper": upper[-1],
                "middle": middle[-1],
                "lower": lower[-1]
            }

            # 4. Moving Averages (EMA) - Trend
            indicators['ema_50'] = talib.EMA(close, timeperiod=50)[-1] if len(close) >= 50 else None
            indicators['ema_200'] = talib.EMA(close, timeperiod=200)[-1] if len(close) >= 200 else None

            # 5. ATR (Average True Range) - Volatility
            if len(high) == len(low) == len(close):
                atr = talib.ATR(high, low, close, timeperiod=14)
                indicators['atr'] = atr[-1]

            return indicators

        except Exception as e:
            logger.error(f"Error calculating technical indicators: {e}")
            return {}