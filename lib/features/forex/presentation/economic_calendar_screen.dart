import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/economic_event.dart';
import 'economic_calendar_providers.dart';

class EconomicCalendarScreen extends ConsumerStatefulWidget {
  const EconomicCalendarScreen({super.key});

  @override
  ConsumerState<EconomicCalendarScreen> createState() => _EconomicCalendarScreenState();
}

class _EconomicCalendarScreenState extends ConsumerState<EconomicCalendarScreen> {
  // Initially select all impact levels
  final Set<String> _selectedImpacts = {'High', 'Medium', 'Low'};

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(economicCalendarProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Economic Calendar'),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: eventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (events) {
                // Filter events based on selected impacts
                final filteredEvents = events.where((event) {
                  return _selectedImpacts.contains(event.impact);
                }).toList();

                if (filteredEvents.isEmpty) {
                  return const Center(child: Text('No events found'));
                }

                return ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: Text(
                          _formatTime(event.time),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        title: Text(event.title),
                        subtitle: Text('${event.currency} • ${event.impact}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Fcst: ${event.forecast}'),
                            Text('Prev: ${event.previous}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        children: ['High', 'Medium', 'Low'].map((impact) {
          return FilterChip(
            label: Text(impact),
            selected: _selectedImpacts.contains(impact),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  _selectedImpacts.add(impact);
                } else {
                  _selectedImpacts.remove(impact);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }
}