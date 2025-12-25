// lib/features/agents/logic/conflict_resolver.dart
import '../../../core/utils/app_logger.dart';

/// Represents a proposed trading action from an agent
class TradeSignal {
  final String agentId;
  final String symbol;
  final String action; // 'BUY' or 'SELL'
  final double confidence;
  final DateTime timestamp;

  TradeSignal({
    required this.agentId,
    required this.symbol,
    required this.action,
    required this.confidence,
    required this.timestamp,
  });

  @override
  String toString() => 'Signal($agentId, $symbol, $action, $confidence)';
}

class ConflictResolver {
  /// Resolves conflicts between multiple trade signals.
  ///
  /// Logic:
  /// 1. Group signals by currency pair (symbol).
  /// 2. For each pair, check if there are opposing signals (BUY vs SELL).
  /// 3. If opposing signals exist, calculate the total confidence for each side.
  /// 4. The side with the higher total confidence wins.
  /// 5. Returns the single best signal (highest confidence) from the winning side.
  List<TradeSignal> resolve(List<TradeSignal> signals) {
    if (signals.isEmpty) return [];

    final List<TradeSignal> finalSignals = [];
    final Map<String, List<TradeSignal>> signalsBySymbol = {};

    // Group by symbol
    for (var signal in signals) {
      if (!signalsBySymbol.containsKey(signal.symbol)) {
        signalsBySymbol[signal.symbol] = [];
      }
      signalsBySymbol[signal.symbol]!.add(signal);
    }

    // Process each symbol
    signalsBySymbol.forEach((symbol, pairSignals) {
      AppLogger.info('Resolving conflicts for $symbol with ${pairSignals.length} signals');

      final winningSignal = _resolvePairConflicts(pairSignals);
      if (winningSignal != null) {
        finalSignals.add(winningSignal);
        AppLogger.info('Winner for $symbol: ${winningSignal.action} by ${winningSignal.agentId}');
      } else {
        AppLogger.warning('Conflict resolution resulted in no action for $symbol (Tie or low confidence)');
      }
    });

    return finalSignals;
  }

  TradeSignal? _resolvePairConflicts(List<TradeSignal> signals) {
    double buyConfidence = 0.0;
    double sellConfidence = 0.0;

    TradeSignal? bestBuySignal;
    TradeSignal? bestSellSignal;

    for (var signal in signals) {
      if (signal.action.toUpperCase() == 'BUY') {
        buyConfidence += signal.confidence;
        if (bestBuySignal == null || signal.confidence > bestBuySignal.confidence) {
          bestBuySignal = signal;
        }
      } else if (signal.action.toUpperCase() == 'SELL') {
        sellConfidence += signal.confidence;
        if (bestSellSignal == null || signal.confidence > bestSellSignal.confidence) {
          bestSellSignal = signal;
        }
      }
    }

    // Determine winner
    if (buyConfidence > sellConfidence) {
      return bestBuySignal;
    } else if (sellConfidence > buyConfidence) {
      return bestSellSignal;
    } else {
      // Tie - avoid trading to be safe
      return null;
    }
  }
}