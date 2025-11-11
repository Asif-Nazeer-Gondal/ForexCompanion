// lib/features/forex/data/forex_service.dart (REWRITTEN)

import 'dart:convert';
import 'package:http/http.dart' as http;
// import '../domain/models/forex_rate.dart';
import 'package:forex_companion/features/forex/domain/models/forex_rate.dart';


/// Abstract contract for the Forex Data Service.
abstract class ForexService {
  Future<List<ForexRate>> fetchExchangeRates();
}

/// Implementation of the ForexService that interacts with an external API.
class ForexServiceImpl implements ForexService {
  // NOTE: Replace with your actual live data endpoint if you have one.
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest/USD';

  @override
  Future<List<ForexRate>> fetchExchangeRates() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final Map<String, dynamic> rates = json['rates'] ?? {};

      if (rates.isEmpty) {
        // Return an empty list instead of throwing an error if API response is valid but rates are empty.
        return [];
      }

      // 1. Capture the exact time the data was fetched
      final DateTime fetchTime = DateTime.now();

      // 2. Map API response to domain model list (ForexRate)
      return rates.entries.map((entry) {
        return ForexRate(
          currencyPair: 'USD/${entry.key}',
          rate: (entry.value as num).toDouble(),
          timestamp: fetchTime, // 🌟 This line is now valid because ForexRate has a 'timestamp' parameter
        );
      }).toList();
    } else {
      // It's generally better to throw a custom DataFailure/ServerFailure defined in the Domain layer,
      // but for this level, a generic Exception is fine.
      throw Exception('Failed to load exchange rates: ${response.statusCode}');
    }
  }
}