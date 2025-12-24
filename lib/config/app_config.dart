/// Application configuration constants
class AppConfig {
  // Forex API Configuration
  static const String forexApiKey = 'YOUR_API_KEY_HERE';
  static const String forexApiBaseUrl = 'https://api.exchangerate-api.com/v4';

  // Alternative free Forex APIs you can use:
  // 1. https://api.exchangerate.host/latest
  // 2. https://api.currencyapi.com/v3/latest
  // 3. https://api.fixer.io/latest (requires API key)
  // 4. https://api.frankfurter.app/latest (free, no API key)

  // Cache Configuration
  static const Duration cacheExpiration = Duration(minutes: 30);

  // Network Configuration
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // App Metadata
  static const String appName = 'ForexCompanion';
  static const String appVersion = '1.0.0';

  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
  static const bool enableDebugLogging = true;
}