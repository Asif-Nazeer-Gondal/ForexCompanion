// lib/features/news/data/news_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/utils/app_logger.dart';
import '../domain/models/news_article.dart';

class NewsService {
  final http.Client _client;
  final String _baseUrl;
  final String _apiKey;

  NewsService({
    http.Client? client,
    String? baseUrl,
    String? apiKey,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? 'https://newsapi.org/v2',
        _apiKey = apiKey ?? '';

  Future<List<NewsArticle>> fetchForexNews() async {
    if (_apiKey.isEmpty) {
      AppLogger.warning('News API key is missing. Returning empty list.');
      return [];
    }

    try {
      // Fetching news about 'forex' or 'currency trading'
      final uri = Uri.parse('$_baseUrl/everything?q=forex OR "currency trading"&language=en&sortBy=publishedAt&apiKey=$_apiKey');
      
      AppLogger.info('Fetching forex news from $uri');
      
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articlesData = data['articles'] as List<dynamic>? ?? [];
        
        final articles = articlesData
            .map((e) => NewsArticle.fromJson(e as Map<String, dynamic>))
            .toList();
            
        AppLogger.info('Successfully fetched ${articles.length} news articles');
        return articles;
      } else {
        AppLogger.error('Failed to fetch news: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to fetch news: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error fetching forex news', e);
      rethrow;
    }
  }
  
  void dispose() {
    _client.close();
  }
}