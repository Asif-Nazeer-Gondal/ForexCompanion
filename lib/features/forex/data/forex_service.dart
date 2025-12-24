// lib/features/forex/data/forex_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
// CORRECT:
import '../../../config/app_config.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/utils/app_logger.dart';
import '../domain/models/forex_rate.dart';


class ForexService {
  final http.Client _client;
  final String _baseUrl;
  final String? _apiKey;

  ForexService({
    http.Client? client,
    String? baseUrl,
    String? apiKey,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.forexApiBaseUrl,
        _apiKey = apiKey ?? AppConfig.forexApiKey;

  /// Fetch all forex rates with retry logic
  Future<List<ForexRate>> fetchRates() async {
    final r = RetryOptions(
      maxAttempts: 3,
      delayFactor: const Duration(seconds: 2),
      randomizationFactor: 0.25,
    );

    return await r.retry(
          () => _performFetchRates(),
      retryIf: (e) => e is ServerException || e is NetworkException,
      onRetry: (e) {
        AppLogger.warning('Retrying forex rates fetch after error: $e');
      },
    );
  }

  Future<List<ForexRate>> _performFetchRates() async {
    try {
      final uri = Uri.parse('$_baseUrl/USD');

      AppLogger.debug('Fetching from: $uri');

      final response = await _client.get(
        uri,
        headers: _buildHeaders(),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw NetworkException('Request timeout');
        },
      );

      if (response.statusCode == 200) {
        return _parseRatesResponse(response.body);
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error: ${response.statusCode}');
      } else if (response.statusCode == 429) {
        throw ServerException('Rate limit exceeded');
      } else {
        throw ServerException('Failed with status: ${response.statusCode}');
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      AppLogger.error('Error in fetchRates', e);
      throw NetworkException('Network error: $e');
    }
  }

  Future<ForexRate> fetchSpecificRate({
    required String from,
    required String to,
  }) async {
    final r = RetryOptions(maxAttempts: 3);

    return await r.retry(
          () => _performFetchSpecificRate(from, to),
      retryIf: (e) => e is ServerException || e is NetworkException,
    );
  }

  Future<ForexRate> _performFetchSpecificRate(String from, String to) async {
    try {
      final uri = Uri.parse('$_baseUrl/$from');

      final response = await _client.get(
        uri,
        headers: _buildHeaders(),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;

        if (rates.containsKey(to)) {
          return ForexRate(
            from: from,
            to: to,
            rate: (rates[to] as num).toDouble(),
            timestamp: DateTime.now(),
          );
        } else {
          throw ServerException('Currency $to not found');
        }
      } else {
        throw ServerException('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }

  Future<List<ForexRate>> fetchHistoricalRates({
    required String currency,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Implement historical rates fetching if your API supports it
    throw UnimplementedError('Historical rates not yet implemented');
  }

  List<ForexRate> _parseRatesResponse(String responseBody) {
    try {
      final data = json.decode(responseBody);
      final base = data['base'] as String;
      final rates = data['rates'] as Map<String, dynamic>;
      final timestamp = DateTime.now();

      return rates.entries.map((entry) {
        return ForexRate(
          from: base,
          to: entry.key,
          rate: (entry.value as num).toDouble(),
          timestamp: timestamp,
        );
      }).toList();
    } catch (e) {
      AppLogger.error('Error parsing rates response', e);
      throw ServerException('Failed to parse response: $e');
    }
  }

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_apiKey != null && _apiKey!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_apiKey';
    }

    return headers;
  }

  void dispose() {
    _client.close();
  }
}