// lib/state/providers/conflict_resolver_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/offline/conflict_resolver.dart';

final conflictResolverProvider = Provider<ConflictResolver>((ref) {
  return ConflictResolver();
});