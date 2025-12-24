// lib/features/forex/domain/repositories/forex_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:forex_companion/features/forex/domain/models/forex_rate.dart';
import 'package:fpdart/fpdart.dart';  // ✓ Keep this one
import '../../../core/error/failures.dart';
import '../models/forex_rate.dart';

abstract class ForexRepository {
  /// Fetches all available forex rates
  /// Returns Either<Failure, List<ForexRate>>
  Future<Either<Failure, List<ForexRate>>> getForexRates();

  /// Fetches a specific forex rate for currency pair
  /// Returns Either<Failure, ForexRate>
  Future<Either<Failure, ForexRate>> getSpecificRate({
    required String fromCurrency,
    required String toCurrency,
  });

  /// Fetches historical rates for a date range
  Future<Either<Failure, List<ForexRate>>> getHistoricalRates({
    required String currency,
    required DateTime startDate,
    required DateTime endDate,
  });
}