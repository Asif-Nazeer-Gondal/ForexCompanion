// lib/state/providers/local_cache_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/offline/local_cache.dart';

final localCacheProvider = Provider<LocalCache>((ref) {
  return LocalCache();
});