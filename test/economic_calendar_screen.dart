import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/models/calendar_event.dart';
import '../domain/services/economic_calendar_service.dart';

class EconomicCalendarScreen extends StatefulWidget {
  const EconomicCalendarScreen({super.key});

  @override
  State<EconomicCalendarScreen> createState() => _EconomicCalendarScreenState();
}

class _EconomicCalendarScreenState extends State<EconomicCalendarScreen> {
  final EconomicCalendarService _service = EconomicCalendarService();
  DateTime _selectedDate = DateTime.now();
  List<CalendarEvent> _events = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    final events = await _service.getEvents(_selectedDate);
    if (mounted) {
      setState(() {
        _events = events;
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadEvents();
    }
  }

  Color _getImpactColor(Impact impact) {
    switch (impact) {
      case Impact.high:
        return Colors.red;
      case Impact.medium:
        return Colors.orange;
      case Impact.low:
        return Colors.yellow.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Economic Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            width: double.infinity,
            child: Text(
              DateFormat.yMMMMEEEEd().format(_selectedDate),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _events.isEmpty
                    ? const Center(child: Text('No events scheduled for this day.'))
                    : ListView.builder(
                        itemCount: _events.length,
                        itemBuilder: (context, index) {
                          final event = _events[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat.jm().format(event.time),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getImpactColor(event.impact)
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                              color: _getImpactColor(event.impact)),
                                        ),
                                        child: Text(
                                          event.impact.name.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: _getImpactColor(event.impact),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        event.currency,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    event.title,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildDataColumn(context, 'Actual',
                                          event.actual ?? '--'),
                                      _buildDataColumn(context, 'Forecast',
                                          event.forecast ?? '--'),
                                      _buildDataColumn(context, 'Previous',
                                          event.previous ?? '--'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataColumn(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}