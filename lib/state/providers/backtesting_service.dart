// lib/features/backtesting/domain/services/backtesting_service.dart
import '../../../forex/domain/models/forex_rate.dart';
import '../../../trading/domain/models/trade_order.dart';

class BacktestResult {
  final double initialBalance;
  final double finalBalance;
  final int totalTrades;
  final int winningTrades;
  final int losingTrades;
  final double maxDrawdown;
  final List<TradeOrder> trades;

  BacktestResult({
    required this.initialBalance,
    required this.finalBalance,
    required this.totalTrades,
    required this.winningTrades,
    required this.losingTrades,
    required this.maxDrawdown,
    required this.trades,
  });

  double get totalProfit => finalBalance - initialBalance;
  double get returnOnInvestment => initialBalance > 0 ? (totalProfit / initialBalance) * 100 : 0;
  double get winRate => totalTrades > 0 ? (winningTrades / totalTrades) * 100 : 0;
}

abstract class TradingStrategy {
  String get name;
  /// Returns a trade signal based on the current rate and history.
  /// Returns [TradeType.buy], [TradeType.sell], or null for no action.
  TradeType? analyze(ForexRate currentRate, List<ForexRate> history);
}

class SimpleMovingAverageStrategy implements TradingStrategy {
  final int period;

  SimpleMovingAverageStrategy({this.period = 14});

  @override
  String get name => 'SMA ($period)';

  @override
  TradeType? analyze(ForexRate currentRate, List<ForexRate> history) {
    if (history.length < period + 1) return null;

    // Calculate SMA for current and previous
    double getSMA(int endIndex) {
      double sum = 0;
      for (int i = 0; i < period; i++) {
        sum += history[endIndex - i].rate;
      }
      return sum / period;
    }

    final currentSMA = getSMA(history.length - 1);
    final previousSMA = getSMA(history.length - 2);
    
    final currentPrice = currentRate.rate;
    final previousPrice = history[history.length - 2].rate;

    // Crossover logic: Price crosses SMA
    // Buy if price crosses above SMA
    if (previousPrice < previousSMA && currentPrice > currentSMA) {
      return TradeType.buy;
    }
    // Sell if price crosses below SMA
    else if (previousPrice > previousSMA && currentPrice < currentSMA) {
      return TradeType.sell;
    }

    return null;
  }
}

class BacktestingService {
  /// Runs a backtest simulation.
  /// 
  /// [data] is the historical price data.
  /// [strategy] is the logic to test.
  /// [initialBalance] is the starting account balance.
  /// [tradeAmount] is the fixed amount of base currency to trade per signal.
  BacktestResult runBacktest({
    required List<ForexRate> data,
    required TradingStrategy strategy,
    double initialBalance = 10000.0,
    double tradeAmount = 1000.0, // Units of base currency
  }) {
    double balance = initialBalance;
    double positionSize = 0; // Units held
    double maxBalance = initialBalance;
    double maxDrawdown = 0.0;
    
    int winningTrades = 0;
    int losingTrades = 0;
    List<TradeOrder> trades = [];
    List<ForexRate> history = [];

    // Sort data by date just in case
    final sortedData = List<ForexRate>.from(data)..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    for (var i = 0; i < sortedData.length; i++) {
      final rate = sortedData[i];
      history.add(rate);

      // Need enough history for indicators? Strategy handles this check (returns null if not enough data)
      final signal = strategy.analyze(rate, history);

      if (signal == TradeType.buy && positionSize == 0) {
        // Open Long Position
        // Check if we have enough balance
        final cost = tradeAmount * rate.rate;
        if (balance >= cost) {
          balance -= cost;
          positionSize = tradeAmount;
          
          trades.add(TradeOrder(
            id: 'buy_$i',
            symbol: '${rate.baseCurrency}/${rate.quoteCurrency}',
            type: TradeType.buy,
            amount: tradeAmount,
            price: rate.rate,
            timestamp: rate.timestamp,
          ));
        }
      } else if (signal == TradeType.sell && positionSize > 0) {
        // Close Long Position
        final revenue = positionSize * rate.rate;
        // Find entry price (assuming FIFO or single position)
        // Since we only hold one position at a time, the last trade must be the buy.
        final lastBuy = trades.last; 
        final profit = revenue - (lastBuy.price * positionSize);

        balance += revenue;
        positionSize = 0;

        if (profit > 0) winningTrades++;
        else losingTrades++;

        trades.add(TradeOrder(
          id: 'sell_$i',
          symbol: '${rate.baseCurrency}/${rate.quoteCurrency}',
          type: TradeType.sell,
          amount: tradeAmount,
          price: rate.rate,
          timestamp: rate.timestamp,
        ));
      }

      // Calculate Drawdown
      // Current equity = balance + (position value)
      double currentEquity = balance + (positionSize * rate.rate);
      if (currentEquity > maxBalance) {
        maxBalance = currentEquity;
      }
      
      if (maxBalance > 0) {
        final drawdown = (maxBalance - currentEquity) / maxBalance * 100;
        if (drawdown > maxDrawdown) {
          maxDrawdown = drawdown;
        }
      }
    }

    // Close any open position at the end
    if (positionSize > 0) {
      final lastRate = sortedData.last;
      final revenue = positionSize * lastRate.rate;
      
      final lastBuy = trades.last;
      final profit = revenue - (lastBuy.price * positionSize);
      
      balance += revenue;
      if (profit > 0) winningTrades++;
      else losingTrades++;
      
      trades.add(TradeOrder(
        id: 'close_end',
        symbol: '${lastRate.baseCurrency}/${lastRate.quoteCurrency}',
        type: TradeType.sell,
        amount: positionSize,
        price: lastRate.rate,
        timestamp: lastRate.timestamp,
      ));
    }

    return BacktestResult(
      initialBalance: initialBalance,
      finalBalance: balance,
      totalTrades: winningTrades + losingTrades,
      winningTrades: winningTrades,
      losingTrades: losingTrades,
      maxDrawdown: maxDrawdown,
      trades: trades,
    );
  }
}