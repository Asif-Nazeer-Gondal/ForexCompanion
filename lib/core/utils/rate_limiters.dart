class RateLimiter {
  final Map<String, DateTime> _lastCallTime = {};
  final Duration minInterval;

  RateLimiter({this.minInterval = const Duration(seconds: 1)});

  bool canMakeRequest(String key) {
    final lastCall = _lastCallTime[key];
    if (lastCall == null) {
      _lastCallTime[key] = DateTime.now();
      return true;
    }

    final timeSinceLastCall = DateTime.now().difference(lastCall);
    if (timeSinceLastCall >= minInterval) {
      _lastCallTime[key] = DateTime.now();
      return true;
    }

    return false;
  }

  Duration getWaitTime(String key) {
    final lastCall = _lastCallTime[key];
    if (lastCall == null) return Duration.zero;

    final timeSinceLastCall = DateTime.now().difference(lastCall);
    final remaining = minInterval - timeSinceLastCall;

    return remaining.isNegative ? Duration.zero : remaining;
  }
}