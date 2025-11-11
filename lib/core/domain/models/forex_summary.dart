// lib/core/domain/models/forex_summary.dart

// lib/core/domain/models/forex_summary.dart
import 'package:forex_companion/features/forex/domain/models/forex_rate.dart'; // Using package import is safer for deep paths
// OR (if you want to stick to relative paths, count how many steps up you need):
// import '../../../features/forex/domain/models/forex_rate.dart';

/// Represents summarized Forex data used by features like Jarvis.
class ForexSummary {
  final List<ForexRate> currentRates;
  final DateTime lastUpdated;

  ForexSummary({
    required this.currentRates,
    required this.lastUpdated,
  });

  /// Converts the summary data into a concise string for AI consumption.
  String toPromptString() {
    if (currentRates.isEmpty) {
      return "No current Forex rates are available in the application.";
    }

    final rateStrings = currentRates
        .map((rate) => "- ${rate.baseCurrency}/${rate.targetCurrency}: ${rate.rate.toStringAsFixed(4)}")
        .join('\n');

    return """
Current Forex Rates (Last Updated: ${lastUpdated.toLocal().toIso8601String().substring(0, 16)}):
$rateStrings
""";
  }
}