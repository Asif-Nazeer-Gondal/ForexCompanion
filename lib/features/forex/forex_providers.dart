// lib/features/forex/forex_providers.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../core/network/network_info.dart';
import 'data/forex_service.dart';
import 'domain/models/forex_rate.dart';
import 'domain/repositories/forex_repository.dart';
import 'domain/repositories/forex_repository_impl.dart';

// Network Info Provider
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(connectivity: Connectivity());
});

// HTTP Client Provider
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

// Forex Service Provider
final forexServiceProvider = Provider<ForexService>((ref) {
  final client = ref.watch(httpClientProvider);
  return ForexService(client: client);
});

// Forex Repository Provider
final forexRepositoryProvider = Provider<ForexRepository>((ref) {
  final service = ref.watch(forexServiceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return ForexRepositoryImpl(
    forexService: service,
    networkInfo: networkInfo,
  );
});

// Forex Rates Provider (AsyncValue) - Auto-refreshing
final forexRatesProvider =
    FutureProvider.autoDispose<List<ForexRate>>((ref) async {
  final repository = ref.watch(forexRepositoryProvider);
  final result = await repository.getForexRates();

  return result.fold(
    (failure) => throw Exception(failure.message ?? 'An error occurred'),
    (rates) => rates,
  );
});

// Specific Rate Provider
final specificRateProvider =
    FutureProvider.family<ForexRate, Map<String, String>>(
        (ref, currencies) async {
  final repository = ref.watch(forexRepositoryProvider);
  final result = await repository.getSpecificRate(
    fromCurrency: currencies['from']!,
    toCurrency: currencies['to']!,
  );

  return result.fold(
    (failure) =>
        Future.error(Exception(failure.message ?? 'An error occurred')),
    (rate) => rate,
  );
});

// Network Status Provider (Stream)
final networkStatusProvider = StreamProvider<bool>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  return networkInfo.onConnectivityChanged;
});