import '../models/calendar_event.dart';

class EconomicCalendarService {
  // Mock data generator
  // In a real app, this would fetch from an API like ForexFactory or similar
  Future<List<CalendarEvent>> getEvents(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate API

    // Generate some mock events based on the date
    return [
      CalendarEvent(
        id: '1',
        title: 'GDP Growth Rate QoQ',
        currency: 'USD',
        impact: Impact.high,
        time: DateTime(date.year, date.month, date.day, 13, 30),
        forecast: '2.1%',
        previous: '2.0%',
      ),
      CalendarEvent(
        id: '2',
        title: 'Unemployment Rate',
        currency: 'EUR',
        impact: Impact.medium,
        time: DateTime(date.year, date.month, date.day, 9, 0),
        forecast: '6.5%',
        previous: '6.5%',
        actual: '6.4%',
      ),
      CalendarEvent(
        id: '3',
        title: 'Retail Sales MoM',
        currency: 'GBP',
        impact: Impact.high,
        time: DateTime(date.year, date.month, date.day, 7, 0),
        forecast: '0.5%',
        previous: '-0.2%',
      ),
      CalendarEvent(
        id: '4',
        title: 'BOJ Core CPI',
        currency: 'JPY',
        impact: Impact.low,
        time: DateTime(date.year, date.month, date.day, 5, 0),
        forecast: '2.8%',
        previous: '2.7%',
      ),
    ]..sort((a, b) => a.time.compareTo(b.time));
  }
}