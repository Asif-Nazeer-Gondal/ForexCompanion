// lib/features/forex/forex_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/use_cases/forex_access_use_case.dart'; // Import Core Contract
import 'data/forex_service.dart';
// Note: Assuming a provider for the main Forex use case exists for the Forex screens.

// --- 1. Data Layer Providers ---

final forexServiceProvider = Provider<ForexService>((ref) {
  // In a real app, you would inject an HTTP client here if needed.
  return ForexServiceImpl();
});

// --- 2. Domain Layer Providers ---

// The provider for the new Forex Access Use Case, which implements the Core contract.
final forexAccessUseCaseProvider = Provider<ForexAccessUseCase>((ref) {
  final service = ref.watch(forexServiceProvider);
  return ForexAccessUseCaseImpl(service);
});

// NOTE: You must integrate the main Forex Use Case provider here for your Forex screens
// if it is not already present.
// Example:
// final forexRateProvider = FutureProvider<List<ForexRate>>((ref) {
//   // Implementation depends on other files you may have
//   return ref.watch(forexAccessUseCaseProvider).getCurrentRates().then((summary) => summary.currentRates);
// });