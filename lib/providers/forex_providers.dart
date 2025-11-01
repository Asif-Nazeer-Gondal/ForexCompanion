// Path: lib/providers/forex_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// This is the most critical line. It must be a relative path.
import '../models/forex_rate.dart';

class ForexService {
  static Future<double> fetchLatestUSDtoPKR() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 280.25;
  }

  static Future<List<ForexRate>> fetchTimeSeries({
    required DateTime start,
    required DateTime end,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final days = end.difference(start).inDays + 1;
    return List.generate(
      days,
          (i) => ForexRate(
        date: start.add(Duration(days: i)),
        rate: 278.0 + i * 0.5,
      ),
    );
  }
}

final latestRateProvider = FutureProvider<double>((ref) async {
  return ForexService.fetchLatestUSDtoPKR();
});

final timeSeriesProvider =
FutureProvider.autoDispose<List<ForexRate>>((ref) async {
  final now = DateTime.now();
  final start = now.subtract(const Duration(days: 6));
  final end = now;
  return ForexService.fetchTimeSeries(start: start, end: end);
});
