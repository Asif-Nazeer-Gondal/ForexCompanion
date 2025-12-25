// lib/features/offline/conflict_resolver.dart
import '../../core/utils/app_logger.dart';

enum ConflictStrategy {
  serverWins,
  clientWins,
  latestWins,
}

class ConflictResolver {
  /// Resolves a conflict between a local entity and a remote entity.
  T resolve<T>({
    required T local,
    required T remote,
    ConflictStrategy strategy = ConflictStrategy.serverWins,
    DateTime Function(T)? getTimestamp,
  }) {
    switch (strategy) {
      case ConflictStrategy.clientWins:
        AppLogger.info('Conflict resolution: Client wins');
        return local;
      case ConflictStrategy.serverWins:
        AppLogger.info('Conflict resolution: Server wins');
        return remote;
      case ConflictStrategy.latestWins:
        if (getTimestamp == null) {
          AppLogger.warning(
              'Timestamp getter required for latestWins strategy. Defaulting to serverWins.');
          return remote;
        }
        final localTime = getTimestamp(local);
        final remoteTime = getTimestamp(remote);

        if (localTime.isAfter(remoteTime)) {
          AppLogger.info('Conflict resolution: Local is newer');
          return local;
        } else {
          AppLogger.info('Conflict resolution: Remote is newer');
          return remote;
        }
    }
  }

  /// Merges two lists of entities based on their IDs.
  List<T> merge<T>({
    required List<T> localList,
    required List<T> remoteList,
    required String Function(T) getId,
    ConflictStrategy strategy = ConflictStrategy.serverWins,
    DateTime Function(T)? getTimestamp,
  }) {
    final Map<String, T> merged = {};

    // Start with local items
    for (var item in localList) {
      merged[getId(item)] = item;
    }

    // Merge remote items
    for (var remoteItem in remoteList) {
      final id = getId(remoteItem);
      if (merged.containsKey(id)) {
        // Conflict detected
        final localItem = merged[id]!;
        merged[id] = resolve(
          local: localItem,
          remote: remoteItem,
          strategy: strategy,
          getTimestamp: getTimestamp,
        );
      } else {
        // New item from server
        merged[id] = remoteItem;
      }
    }

    return merged.values.toList();
  }
}
