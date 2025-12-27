// lib/features/offline/sync_manager.dart
import 'dart:async';
import '../../core/network/network_info.dart';
import '../../core/utils/app_logger.dart';

class SyncManager {
  final NetworkInfo _networkInfo;
  StreamSubscription<bool>? _networkSubscription;
  bool _isSyncing = false;

  SyncManager({required NetworkInfo networkInfo}) : _networkInfo = networkInfo;

  /// Initialize the sync manager to listen for network changes
  void initialize() {
    _networkSubscription = _networkInfo.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        AppLogger.info('Network connection restored. Triggering sync...');
        sync();
      }
    });
  }

  /// Trigger a synchronization process
  Future<void> sync() async {
    if (_isSyncing) {
      AppLogger.info('Sync already in progress. Skipping.');
      return;
    }

    if (!await _networkInfo.isConnected) {
      AppLogger.info('No network connection. Skipping sync.');
      return;
    }

    _isSyncing = true;
    AppLogger.info('Starting synchronization...');

    try {
      // 1. Push pending local changes to server
      await _pushLocalChanges();

      // 2. Pull latest data from server
      await _pullRemoteData();

      AppLogger.info('Synchronization completed successfully.');
    } catch (e, stackTrace) {
      AppLogger.error('Synchronization failed', e, stackTrace);
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _pushLocalChanges() async {
    AppLogger.info('Pushing local changes...');
    
    // Simulate pushing user journal entries or settings
    await Future.delayed(const Duration(milliseconds: 500));
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate work
  }

  Future<void> _pullRemoteData() async {
    AppLogger.info('Pulling remote data...');
    
    // Simulate fetching latest Economic Calendar events
    AppLogger.info('Syncing Economic Calendar events...');
    await Future.delayed(const Duration(milliseconds: 800));

    // Simulate fetching Glossary updates
    AppLogger.info('Syncing Glossary terms...');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void dispose() {
    _networkSubscription?.cancel();
  }
}
