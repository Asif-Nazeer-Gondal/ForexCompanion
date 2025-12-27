import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../forex/presentation/portfolio_websocket_service.dart';

class OpenPosition {
  final String symbol;
  final double units;
  final double entryPrice;
  final double unrealizedPnl;
  final double? stopLoss;
  final double? takeProfit;

  const OpenPosition({
    required this.symbol,
    required this.units,
    required this.entryPrice,
    required this.unrealizedPnl,
    this.stopLoss,
    this.takeProfit,
  });
}

class PortfolioMetrics {
  final double balance;
  final double equity;
  final double marginUsed;
  final double freeMargin;
  final double unrealizedPnl;
  final double marginLevel;
  final List<OpenPosition> openPositions;

  const PortfolioMetrics({
    required this.balance,
    required this.equity,
    required this.marginUsed,
    required this.freeMargin,
    required this.unrealizedPnl,
    required this.marginLevel,
    this.openPositions = const [],
  });

  factory PortfolioMetrics.fromJson(Map<String, dynamic> json) {
    return PortfolioMetrics(
      balance: (json['balance'] as num).toDouble(),
      equity: (json['equity'] as num).toDouble(),
      marginUsed: (json['margin_used'] as num).toDouble(),
      freeMargin: (json['free_margin'] as num).toDouble(),
      unrealizedPnl: (json['unrealized_pnl'] as num).toDouble(),
      marginLevel: (json['margin_level'] as num).toDouble(),
      openPositions: (json['open_positions'] as List<dynamic>?)
              ?.map((e) => OpenPosition(
                    symbol: e['symbol'] as String,
                    units: (e['units'] as num).toDouble(),
                    entryPrice: (e['entry_price'] as num).toDouble(),
                    unrealizedPnl: (e['unrealized_pnl'] as num).toDouble(),
                    stopLoss: e['stop_loss'] != null ? (e['stop_loss'] as num).toDouble() : null,
                    takeProfit: e['take_profit'] != null ? (e['take_profit'] as num).toDouble() : null,
                  ))
              .toList() ??
          [],
    );
  }
}

final portfolioMetricsProvider = StreamProvider<PortfolioMetrics>((ref) {
  final service = ref.watch(portfolioWebsocketServiceProvider);
  service.connect();
  return service.stream.map((data) => PortfolioMetrics.fromJson(data));
});