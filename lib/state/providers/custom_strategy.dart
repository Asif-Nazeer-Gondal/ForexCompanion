// lib/features/strategy/domain/models/custom_strategy.dart
import '../../backtesting/domain/services/backtesting_service.dart';
import '../../forex/domain/models/forex_rate.dart';
import '../../trading/domain/models/trade_order.dart';

class CustomStrategy implements TradingStrategy {
  final String id;
  @override
  final String name;
  final int fastPeriod;
  final int slowPeriod;

  CustomStrategy({
    required this.id,
    required this.name,
    required this.fastPeriod,
    required this.slowPeriod,
  });

  @override
  TradeType? analyze(ForexRate currentRate, List<ForexRate> history) {
    if (history.length < slowPeriod + 1) return null;

    double getSMA(int endIndex, int period) {
      double sum = 0;
      for (int i = 0; i < period; i++) {
        sum += history[endIndex - i].rate;
      }
      return sum / period;
    }

    final currentFastSMA = getSMA(history.length - 1, fastPeriod);
    final previousFastSMA = getSMA(history.length - 2, fastPeriod);
    
    final currentSlowSMA = getSMA(history.length - 1, slowPeriod);
    final previousSlowSMA = getSMA(history.length - 2, slowPeriod);

    // Golden Cross (Fast crosses above Slow) -> Buy
    if (previousFastSMA < previousSlowSMA && currentFastSMA > currentSlowSMA) {
      return TradeType.buy;
    }
    // Death Cross (Fast crosses below Slow) -> Sell
    else if (previousFastSMA > previousSlowSMA && currentFastSMA < currentSlowSMA) {
      return TradeType.sell;
    }

    return null;
  }
}