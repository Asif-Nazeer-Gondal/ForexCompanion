// lib/state/providers/portfolio_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/portfolio/domain/models/portfolio_holding.dart';
import '../../features/trading/domain/models/trade_order.dart';
import 'trade_provider.dart';
import 'watchlist_provider.dart'; // for forexRepositoryProvider

final portfolioProvider = FutureProvider.autoDispose<List<PortfolioHolding>>((ref) async {
  final tradeState = ref.watch(tradeProvider);
  final repository = ref.watch(forexRepositoryProvider);

  final Map<String, double> amounts = {};
  final Map<String, double> costs = {};

  // Calculate holdings from trade history
  for (final order in tradeState.orders) {
    final symbol = order.symbol;
    if (order.type == TradeType.buy) {
      amounts[symbol] = (amounts[symbol] ?? 0) + order.amount;
      costs[symbol] = (costs[symbol] ?? 0) + (order.amount * order.price);
    } else {
      final currentAmount = amounts[symbol] ?? 0;
      if (currentAmount > 0) {
        final avgCost = costs[symbol]! / currentAmount;
        amounts[symbol] = currentAmount - order.amount;
        costs[symbol] = costs[symbol]! - (order.amount * avgCost);
      }
    }
  }

  final List<PortfolioHolding> holdings = [];

  for (final symbol in amounts.keys) {
    final amount = amounts[symbol]!;
    // Filter out closed positions (allowing for small floating point errors)
    if (amount > 0.00001) {
      final parts = symbol.split('/');
      double currentPrice = 0.0;

      if (parts.length == 2) {
        final result = await repository.getSpecificRate(
          fromCurrency: parts[0],
          toCurrency: parts[1],
        );
        result.fold(
          (l) => null, // Handle error gracefully (price remains 0)
          (r) => currentPrice = r.rate,
        );
      }

      holdings.add(PortfolioHolding(
        symbol: symbol,
        amount: amount,
        averagePrice: costs[symbol]! / amount,
        currentPrice: currentPrice,
      ));
    }
  }

  return holdings;
});