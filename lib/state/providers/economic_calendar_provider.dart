// lib/state/providers/economic_calendar_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/calendar/domain/models/economic_event.dart';

final economicCalendarProvider = FutureProvider.autoDispose<List<EconomicEvent>>((ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(seconds: 1));

  final now = DateTime.now();
  
  // Mock data
  return [
    EconomicEvent(
      id: '1',
      title: 'Non-Farm Payrolls',
      currency: 'USD',
      impact: 'High',
      time: now.add(const Duration(hours: 2)),
      forecast: '180K',
      previous: '175K',
    ),
    EconomicEvent(
      id: '2',
      title: 'Unemployment Rate',
      currency: 'USD',
      impact: 'High',
      time: now.add(const Duration(hours: 2)),
      forecast: '3.9%',
      previous: '3.9%',
    ),
    EconomicEvent(
      id: '3',
      title: 'ECB Interest Rate Decision',
      currency: 'EUR',
      impact: 'High',
      time: now.add(const Duration(days: 1, hours: 5)),
      forecast: '4.25%',
      previous: '4.50%',
    ),
    EconomicEvent(
      id: '4',
      title: 'CPI YoY',
      currency: 'GBP',
      impact: 'Medium',
      time: now.add(const Duration(days: 2, hours: 1)),
      forecast: '2.1%',
      previous: '2.3%',
    ),
  ];
});