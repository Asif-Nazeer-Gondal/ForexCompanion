import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../domain/models/economic_event.dart';
import 'economic_calendar_providers.dart';

class EconomicCalendarScreen extends ConsumerStatefulWidget {
  const EconomicCalendarScreen({super.key});

  @override
  ConsumerState<EconomicCalendarScreen> createState() => _EconomicCalendarScreenState();
}

class _EconomicCalendarScreenState extends ConsumerState<EconomicCalendarScreen> {
  final Set<String> _selectedImpacts = {'High', 'Medium', 'Low'};

  void _toggleImpact(String impact) {
    setState(() {
      if (_selectedImpacts.contains(impact)) {
        if (_selectedImpacts.length > 1) {
          _selectedImpacts.remove(impact);
        }
      } else {
        _selectedImpacts.add(impact);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(economicCalendarProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Economic Calendar'),
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            child: Row(
              children: [
                const Text('Impact: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Wrap(
                  spacing: 8,
                  children: ['High', 'Medium', 'Low'].map((impact) {
                    final isSelected = _selectedImpacts.contains(impact);
                    Color color;
                    switch (impact) {
                      case 'High': color = Colors.red; break;
                      case 'Medium': color = Colors.orange; break;
                      default: color = Colors.blue;
                    }

                    return FilterChip(
                      label: Text(impact),
                      selected: isSelected,
                      onSelected: (_) => _toggleImpact(impact),
                      checkmarkColor: Colors.white,
                      selectedColor: color.withOpacity(0.8),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          // Event List
          Expanded(
            child: eventsAsync.when(
              data: (events) {
                final filteredEvents = events
                    .where((e) => _selectedImpacts.contains(e.impact))
                    .toList()
                  ..sort((a, b) => a.time.compareTo(b.time));

                if (filteredEvents.isEmpty) {
                  return const Center(child: Text('No events found'));
                }

                return RefreshIndicator(
                  onRefresh: () => ref.refresh(economicCalendarProvider.future),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      return _EventCard(event: filteredEvents[index]);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text('Error loading events: $err'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(economicCalendarProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EconomicEvent event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, HH:mm');
    
    Color impactColor;
    switch (event.impact) {
      case 'High': impactColor = Colors.red; break;
      case 'Medium': impactColor = Colors.orange; break;
      default: impactColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: impactColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateFormat.format(event.time),
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      Text(
                        event.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    event.currency,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildValueColumn(context, 'Actual', event.actual),
                _buildValueColumn(context, 'Forecast', event.forecast),
                _buildValueColumn(context, 'Previous', event.previous),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueColumn(BuildContext context, String label, String? value) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value ?? '--',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}