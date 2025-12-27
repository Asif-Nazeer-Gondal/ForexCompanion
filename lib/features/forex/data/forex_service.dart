// lib/features/forex/data/forex_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../core/utils/app_logger.dart';
import '../domain/models/forex_rate.dart';

class ForexService {
  final http.Client _client;
  final String _baseUrl = 'https://api.frankfurter.app';

  ForexService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches latest rates for major currencies against USD
  Future<List<ForexRate>> getLatestRates() async {
    final url = Uri.parse('$_baseUrl/latest?from=USD');
    
    try {
      final response = await _client.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ratesMap = data['rates'] as Map<String, dynamic>;
        final date = DateTime.parse(data['date']);
        
        return ratesMap.entries.map((e) {
          return ForexRate(
            baseCurrency: 'USD',
            quoteCurrency: e.key,
            rate: (e.value as num).toDouble(),
            timestamp: date,
          );
        }).toList();
      } else {
        throw Exception('Failed to load rates: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error fetching rates', e);
      rethrow;
    }
  }

  /// Fetches historical rates for a currency pair
  Future<List<ForexRate>> getHistoricalRates(String symbol, String period) async {
    // Currency format expected: "EUR/USD"
    final parts = symbol.replaceAll('-', '/').split('/');
    if (parts.length != 2) throw Exception('Invalid currency pair format');
    
    final base = parts[0];
    final quote = parts[1];
    
    final endDate = DateTime.now();
    DateTime startDate;

    switch (period) {
      case '1W':
        startDate = endDate.subtract(const Duration(days: 7));
        break;
      case '1M':
        startDate = endDate.subtract(const Duration(days: 30));
        break;
      case '3M':
        startDate = endDate.subtract(const Duration(days: 90));
        break;
      case '1Y':
        startDate = endDate.subtract(const Duration(days: 365));
        break;
      case '1D':
      default:
        startDate = endDate.subtract(const Duration(days: 5)); 
        break;
    }

    final startStr = DateFormat('yyyy-MM-dd').format(startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(endDate);

    final url = Uri.parse('$_baseUrl/$startStr..$endStr?from=$base&to=$quote');
    
    try {
      final response = await _client.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ratesMap = data['rates'] as Map<String, dynamic>;
        
        List<ForexRate> rates = [];
        ratesMap.forEach((dateStr, rateData) {
           if (rateData is Map && rateData.containsKey(quote)) {
             rates.add(ForexRate(
               baseCurrency: base,
               quoteCurrency: quote,
               rate: (rateData[quote] as num).toDouble(),
               timestamp: DateTime.parse(dateStr),
             ));
           }
        });
        
        rates.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        return rates;
      } else throw Exception('Failed to load historical rates');
    } catch (e) { AppLogger.error('Error fetching historical rates', e); rethrow; }
  }
}