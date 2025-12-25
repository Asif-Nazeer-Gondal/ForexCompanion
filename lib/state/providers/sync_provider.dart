// lib/state/providers/sync_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/offline/sync_manager.dart';
import 'news_provider.dart'; // For networkInfoProvider

final syncManagerProvider = Provider<SyncManager>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  final manager = SyncManager(networkInfo: networkInfo);
  
  manager.initialize();
  ref.onDispose(() => manager.dispose());
  
  return manager;
});