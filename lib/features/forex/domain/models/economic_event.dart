class EconomicEvent {
  final String id;
  final String title;
  final String currency;
  final String impact;
  final DateTime time;
  final String forecast;
  final String previous;

  const EconomicEvent({
    required this.id,
    required this.title,
    required this.currency,
    required this.impact,
    required this.time,
    required this.forecast,
    required this.previous,
  });
}