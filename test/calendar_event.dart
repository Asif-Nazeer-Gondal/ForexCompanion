enum Impact { low, medium, high }

class CalendarEvent {
  final String id;
  final String title;
  final String currency;
  final Impact impact;
  final DateTime time;
  final String? forecast;
  final String? previous;
  final String? actual;

  const CalendarEvent({
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