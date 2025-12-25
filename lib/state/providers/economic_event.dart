// lib/features/calendar/domain/models/economic_event.dart
class EconomicEvent {
  final String id;
  final String title;
  final String currency;
  final String impact; // 'High', 'Medium', 'Low'
  final DateTime time;
  final String? forecast;
  final String? previous;
  final String? actual;

  EconomicEvent({
    required this.id,
    required this.title,
    required this.currency,
    required this.impact,
    required this.time,
    this.forecast,
    this.previous,
    this.actual,
  });
}