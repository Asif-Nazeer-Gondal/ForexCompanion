// lib/state/providers/correlation_provider.dart
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'watchlist_provider.dart'; // for forexRepositoryProvider

final correlationPairsProvider = Provider<List<String>>((ref) {
  return ['EUR/USD', 'GBP/USD', 'USD/JPY', 'AUD/USD', 'USD/CAD', 'NZD/USD', 'USD/CHF'];
});

final correlationMatrixProvider = FutureProvider.autoDispose<Map<String, Map<String, double>>>((ref) async {
  final repository = ref.watch(forexRepositoryProvider);
  final pairs = ref.watch(correlationPairsProvider);
  
  // Fetch history for last 30 days
  final endDate = DateTime.now();
  final startDate = endDate.subtract(const Duration(days: 30));
  
  final Map<String, List<double>> historyData = {};
  
  // Fetch data for each pair
  await Future.wait(pairs.map((pair) async {
    final result = await repository.getHistoricalRates(
      currency: pair,
      startDate: startDate,
      endDate: endDate,
    );
    
    result.fold(
      (failure) => null, // Skip on error
      (rates) {
        // We assume rates are sorted by date from the repository
        historyData[pair] = rates.map((r) => r.rate).toList();
      },
    );
  }));

  // Calculate Correlation Matrix
  final Map<String, Map<String, double>> matrix = {};
  
  for (var xPair in pairs) {
    matrix[xPair] = {};
    for (var yPair in pairs) {
      if (xPair == yPair) {
        matrix[xPair]![yPair] = 1.0;
      } else {
        final xData = historyData[xPair];
        final yData = historyData[yPair];
        
        if (xData != null && yData != null && xData.isNotEmpty && yData.isNotEmpty) {
          // Align lengths if necessary (take min length to compare overlapping days)
          final length = min(xData.length, yData.length);
          // Taking the most recent data points
          final x = xData.sublist(xData.length - length);
          final y = yData.sublist(yData.length - length);
          
          matrix[xPair]![yPair] = _calculatePearsonCorrelation(x, y);
        } else {
          matrix[xPair]![yPair] = 0.0;
        }
      }
    }
  }
  
  return matrix;
});

double _calculatePearsonCorrelation(List<double> x, List<double> y) {
  final n = x.length;
  if (n != y.length || n == 0) return 0.0;

  final sumX = x.reduce((a, b) => a + b);
  final sumY = y.reduce((a, b) => a + b);
  
  final sumX2 = x.map((e) => e * e).reduce((a, b) => a + b);
  final sumY2 = y.map((e) => e * e).reduce((a, b) => a + b);
  
  double sumXY = 0;
  for (int i = 0; i < n; i++) {
    sumXY += x[i] * y[i];
  }
  
  final numerator = (n * sumXY) - (sumX * sumY);
  final denominator = sqrt(((n * sumX2) - (sumX * sumX)) * ((n * sumY2) - (sumY * sumY)));
  
  if (denominator == 0) return 0.0;
  
  // Clamp result between -1 and 1 to handle floating point errors
  final result = numerator / denominator;
  return result.clamp(-1.0, 1.0);
}