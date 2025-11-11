// lib/core/domain/use_cases/forex_access_use_case.dart (FIXED using package import)

// 🌟 FIX: Use the package import to guarantee the location is found
// Assuming your project name is 'forex_companion'
import 'package:forex_companion/core/domain/models/forex_summary.dart';

/// Contract for accessing simplified, read-only Forex information.
abstract class ForexAccessUseCase {
  /// Fetches the last recorded Forex rates.
  Future<ForexSummary> getCurrentRates();
}