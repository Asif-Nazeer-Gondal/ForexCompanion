import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/economic_event.dart';

final economicCalendarProvider = FutureProvider<List<EconomicEvent>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(seconds: 1));

  final now = DateTime.now();
  
  // Mock Data
  return [
    EconomicEvent(
      id: '1',
      title: 'Non-Farm Payrolls',
      currency: 'USD',
      impact: 'High',
      time: now.add(const Duration(hours: 2)),
      forecast: '180k',
      previous: '150k',
    ),
    EconomicEvent(
      id: '2',
      title: 'Unemployment Rate',
      currency: 'USD',
      impact: 'High',
      time: now.add(const Duration(hours: 2)),
      forecast: '3.7%',
      previous: '3.7%',
    ),
    EconomicEvent(
      id: '3',
      title: 'CPI YoY',
      currency: 'EUR',
      impact: 'High',
      time: now.add(const Duration(days: 1, hours: 4)),
      forecast: '2.4%',
      previous: '2.9%',
    ),
    EconomicEvent(
      id: '4',
      title: 'Retail Sales',
      currency: 'GBP',
      impact: 'Medium',
      time: now.add(const Duration(days: 1, hours: 1)),
      forecast: '0.2%',
      previous: '0.0%',
    ),
    EconomicEvent(
      id: '5',
      title: 'Trade Balance',
      currency: 'JPY',
      impact: 'Low',
      time: now.subtract(const Duration(hours: 5)),
      forecast: '-0.5T',
      previous: '-0.6T',
      actual: '-0.4T',
    ),
  ];
});