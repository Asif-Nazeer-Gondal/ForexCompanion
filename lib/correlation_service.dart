class CorrelationService {
  // Mock correlation data (Daily timeframe)
  // In a production app, this would be calculated from historical price data
  // Range: -1.0 to 1.0
  final Map<String, Map<String, double>> _correlations = {
    'EUR/USD': {
      'EUR/USD': 1.00, 'GBP/USD': 0.89, 'AUD/USD': 0.82, 'NZD/USD': 0.78,
      'USD/CHF': -0.94, 'USD/CAD': -0.55, 'USD/JPY': 0.60,
    },
    'GBP/USD': {
      'EUR/USD': 0.89, 'GBP/USD': 1.00, 'AUD/USD': 0.75, 'NZD/USD': 0.72,
      'USD/CHF': -0.85, 'USD/CAD': -0.45, 'USD/JPY': 0.55,
    },
    'AUD/USD': {
      'EUR/USD': 0.82, 'GBP/USD': 0.75, 'AUD/USD': 1.00, 'NZD/USD': 0.92,
      'USD/CHF': -0.78, 'USD/CAD': -0.65, 'USD/JPY': 0.75,
    },
    'NZD/USD': {
      'EUR/USD': 0.78, 'GBP/USD': 0.72, 'AUD/USD': 0.92, 'NZD/USD': 1.00,
      'USD/CHF': -0.72, 'USD/CAD': -0.60, 'USD/JPY': 0.65,
    },
    'USD/CHF': {
      'EUR/USD': -0.94, 'GBP/USD': -0.85, 'AUD/USD': -0.78, 'NZD/USD': -0.72,
      'USD/CHF': 1.00, 'USD/CAD': 0.48, 'USD/JPY': -0.58,
    },
    'USD/CAD': {
      'EUR/USD': -0.55, 'GBP/USD': -0.45, 'AUD/USD': -0.65, 'NZD/USD': -0.60,
      'USD/CHF': 0.48, 'USD/CAD': 1.00, 'USD/JPY': -0.25,
    },
    'USD/JPY': {
      'EUR/USD': 0.60, 'GBP/USD': 0.55, 'AUD/USD': 0.75, 'NZD/USD': 0.65,
      'USD/CHF': -0.58, 'USD/CAD': -0.25, 'USD/JPY': 1.00,
    },
  };

  List<String> get pairs => _correlations.keys.toList();

  double getCorrelation(String pair1, String pair2) {
    // Access nested map safely
    return _correlations[pair1]?[pair2] ?? 0.0;
  }
}