import '../models/forex_rate.dart';

/// Contract for fetching and managing Forex rates data.
abstract class ForexRepository {
  /// Fetches a list of live Forex rates from an external service.
  Future<List<ForexRate>> getLiveRates();
}