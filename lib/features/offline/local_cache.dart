// lib/features/offline/local_cache.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/utils/app_logger.dart';
import '../forex/domain/models/forex_rate.dart';
import '../news/domain/models/news_article.dart';

class LocalCache {
  static const String _ratesBoxName = 'forex_rates';
  static const String _newsBoxName = 'news_articles';

  late Box _ratesBox;
  late Box _newsBox;

  // Singleton instance
  static final LocalCache _instance = LocalCache._internal();
  factory LocalCache() => _instance;
  LocalCache._internal();

  /// Initialize Hive boxes
  Future<void> initialize() async {
    try {
      // Hive.initFlutter() is called in SettingsService, so we just open boxes
      _ratesBox = await Hive.openBox(_ratesBoxName);
      _newsBox = await Hive.openBox(_newsBoxName);
      AppLogger.info('LocalCache initialized');
    } catch (e) {
      AppLogger.error('Failed to initialize LocalCache', e);
    }
  }

  // --- Forex Rates ---

  Future<void> cacheForexRates(List<ForexRate> rates) async {
    try {
      final Map<String, Map<String, dynamic>> ratesMap = {};
      for (var rate in rates) {
        final key = '${rate.baseCurrency}/${rate.quoteCurrency}';
        ratesMap[key] = {
          'base': rate.baseCurrency,
          'quote': rate.quoteCurrency,
          'rate': rate.rate,
          'timestamp': rate.timestamp.toIso8601String(),
          'change': rate.change,
          'changePercent': rate.changePercent,
        };
      }
      await _ratesBox.putAll(ratesMap);
    } catch (e) {
      AppLogger.error('Failed to cache forex rates', e);
    }
  }

  List<ForexRate> getCachedForexRates() {
    try {
      return _ratesBox.values.map((data) {
        final map = Map<String, dynamic>.from(data as Map);
        return ForexRate(
          baseCurrency: map['base'],
          quoteCurrency: map['quote'],
          rate: map['rate'],
          timestamp: DateTime.parse(map['timestamp']),
          change: map['change'],
          changePercent: map['changePercent'],
        );
      }).toList();
    } catch (e) {
      AppLogger.error('Failed to get cached forex rates', e);
      return [];
    }
  }

  // --- News ---

  Future<void> cacheNews(List<NewsArticle> articles) async {
    try {
      final Map<String, Map<String, dynamic>> newsMap = {};
      for (var article in articles) {
        newsMap[article.url] = {
          'title': article.title,
          'description': article.description,
          'url': article.url,
          'source': article.source,
          'publishedAt': article.publishedAt.toIso8601String(),
          'imageUrl': article.imageUrl,
        };
      }
      await _newsBox.putAll(newsMap);
    } catch (e) {
      AppLogger.error('Failed to cache news', e);
    }
  }

  List<NewsArticle> getCachedNews() {
    try {
      return _newsBox.values.map((data) {
        final map = Map<String, dynamic>.from(data as Map);
        return NewsArticle(
          title: map['title'],
          description: map['description'],
          url: map['url'],
          source: map['source'],
          publishedAt: DateTime.parse(map['publishedAt']),
          imageUrl: map['imageUrl'],
        );
      }).toList();
    } catch (e) {
      AppLogger.error('Failed to get cached news', e);
      return [];
    }
  }
}
