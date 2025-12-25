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
  Future<List<ForexRate>> fetchRates() async {
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

  /// Fetches a specific exchange rate
  Future<ForexRate> fetchSpecificRate({
    required String from,
    required String to,
  }) async {
    if (from == to) {
      return ForexRate(
        baseCurrency: from,
        quoteCurrency: to,
        rate: 1.0,
        timestamp: DateTime.now(),
      );
    }

    final url = Uri.parse('$_baseUrl/latest?from=$from&to=$to');
    
    try {
      final response = await _client.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ratesMap = data['rates'] as Map<String, dynamic>;
        
        if (!ratesMap.containsKey(to)) {
           throw Exception('Rate for $to not found');
        }

        final rateValue = (ratesMap[to] as num).toDouble();
        final date = DateTime.parse(data['date']);
        
        return ForexRate(
          baseCurrency: from,
          quoteCurrency: to,
          rate: rateValue,
          timestamp: date,
        );
      } else {
        throw Exception('Failed to load rate for $from/$to: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error fetching specific rate', e);
      rethrow;
    }
  }

  /// Fetches historical rates for a currency pair
  Future<List<ForexRate>> fetchHistoricalRates({
    required String currency,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Currency format expected: "EUR/USD"
    final parts = currency.replaceAll('-', '/').split('/');
    if (parts.length != 2) throw Exception('Invalid currency pair format');
    
    final base = parts[0];
    final quote = parts[1];
    final startStr = DateFormat('yyyy-MM-dd').format(startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(endDate);

    final url = Uri.parse('$_baseUrl/$startStr..$endStr?from=$base&to=$quote');
    
    try {
      final response = await _client.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ratesMap = data['rates'] as Map<String, dynamic>;
        
        return ratesMap.entries.map((e) => ForexRate(
          baseCurrency: base, quoteCurrency: quote, rate: (e.value[quote] as num).toDouble(), timestamp: DateTime.parse(e.key)
        )).toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      } else throw Exception('Failed to load historical rates');
    } catch (e) { AppLogger.error('Error fetching historical rates', e); rethrow; }
  }
}