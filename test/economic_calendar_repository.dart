import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/app_logger.dart';
import '../domain/models/economic_event.dart';

class EconomicCalendarRepository {
  final http.Client _client;
  final String _baseUrl;
  final String _apiKey;

  EconomicCalendarRepository({
    http.Client? client,
    String? baseUrl,
    String? apiKey,
  })  : _client = client ?? http.Client(),
        // Using Financial Modeling Prep as a placeholder/example API
        _baseUrl = baseUrl ?? 'https://financialmodelingprep.com/api/v3',
        _apiKey = apiKey ?? 'YOUR_API_KEY';

  Future<List<EconomicEvent>> fetchEvents() async {
    try {
      final uri = Uri.parse('$_baseUrl/economic_calendar?apikey=$_apiKey');
      AppLogger.info('Fetching economic calendar from $uri');

      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => _mapJsonToEvent(json)).toList();
      } else {
        throw Exception('Failed to load economic events: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error fetching economic calendar', e);
      rethrow;
    }
  }

  EconomicEvent _mapJsonToEvent(Map<String, dynamic> json) {
    return EconomicEvent(
      id: json['event'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['event'] ?? 'Unknown Event',
      currency: json['currency'] ?? 'USD',
      impact: json['impact'] ?? 'Low',
      time: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      forecast: json['estimate']?.toString() ?? '-',
      previous: json['previous']?.toString() ?? '-',
    );
  }
}