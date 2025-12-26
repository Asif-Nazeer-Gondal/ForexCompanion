class CurrencyConverterService {
  // Mock exchange rates for demonstration purposes
  // In a production app, these would be fetched from a live Forex API
  final Map<String, double> _rates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'JPY': 110.0,
    'AUD': 1.35,
    'CAD': 1.25,
    'CHF': 0.92,
  };

  List<String> get availableCurrencies => _rates.keys.toList();

  double convert(double amount, String fromCurrency, String toCurrency) {
    final fromRate = _rates[fromCurrency] ?? 1.0;
    final toRate = _rates[toCurrency] ?? 1.0;

    // Convert to USD first (base), then to target
    final inUsd = amount / fromRate;
    return inUsd * toRate;
  }
}