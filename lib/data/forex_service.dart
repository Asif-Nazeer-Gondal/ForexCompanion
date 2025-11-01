// Path: lib/data/forex_service.dart

import '../models/forex_rate.dart'; // Ensure this uses a relative path

class ForexService {
  static Future<double> fetchLatestUSDtoPKR() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 280.25;
  }

  // FIXED: Changed return type to List<ForexRate>
  static Future<List<ForexRate>> fetchTimeSeries({
    required DateTime start,
    required DateTime end,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final days = end.difference(start).inDays + 1;
    return List.generate(
      days,
      // FIXED: Create an instance of ForexRate
          (i) => ForexRate(
        date: start.add(Duration(days: i)),
        rate: 278.0 + i * 0.5,
      ),
    );
  }
}
