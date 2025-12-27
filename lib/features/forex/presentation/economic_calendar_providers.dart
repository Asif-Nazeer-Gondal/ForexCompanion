import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/economic_calendar_repository.dart';
import '../domain/models/economic_event.dart';

final economicCalendarRepositoryProvider = Provider<EconomicCalendarRepository>((ref) {
  return EconomicCalendarRepository();
});

/// Provides the list of economic events asynchronously.
final economicCalendarProvider = FutureProvider<List<EconomicEvent>>((ref) async {
  final repository = ref.watch(economicCalendarRepositoryProvider);
  return repository.fetchEvents();
});