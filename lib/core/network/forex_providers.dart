import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../core/network/network_info.dart';
import '../data/forex_service.dart';
import '../data/repositories/forex_repository_impl.dart';
import '../domain/repositories/forex_repository.dart';
import '../domain/usecases/get_forex_rates.dart';
import '../domain/usecases/get_historical_rates.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

final internetConnectionCheckerProvider = Provider<InternetConnectionChecker>((ref) {
  return InternetConnectionChecker();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.watch(internetConnectionCheckerProvider));
});

final forexServiceProvider = Provider<ForexService>((ref) {
  return ForexService(client: ref.watch(httpClientProvider));
});

final forexRepositoryProvider = Provider<ForexRepository>((ref) {
  return ForexRepositoryImpl(
    remoteDataSource: ref.watch(forexServiceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

final getForexRatesProvider = Provider<GetForexRates>((ref) {
  return GetForexRates(ref.watch(forexRepositoryProvider));
});

final getHistoricalRatesProvider = Provider<GetHistoricalRates>((ref) {
  return GetHistoricalRates(ref.watch(forexRepositoryProvider));
});