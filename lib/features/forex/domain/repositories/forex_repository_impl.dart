// lib/features/forex/data/repositories/forex_repository_impl.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/forex_rate.dart';
import '../../domain/repositories/forex_repository.dart';
import '../forex_service.dart';

/// Concrete implementation of the ForexRepository contract.
/// It uses the ForexService to fetch data and maps it to domain models.
class ForexRepositoryImpl implements ForexRepository {
  final ForexService _service;

  ForexRepositoryImpl(this._service);

  @override
  Future<List<ForexRate>> getLiveRates() {
    // The service already returns the domain model List<ForexRate>,
    // so we just pass the call through.
    return _service.fetchExchangeRates();
  }
}

// Provider to expose the implementation
final forexRepositoryProvider = Provider<ForexRepository>((ref) {
  // Assuming forexServiceProvider is defined in forex_providers.dart
  final service = ref.watch(forexServiceProvider);
  return ForexRepositoryImpl(service);
});