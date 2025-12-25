// lib/features/tools/presentation/session_map_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionMapScreen extends StatefulWidget {
  const SessionMapScreen({super.key});

  @override
  State<SessionMapScreen> createState() => _SessionMapScreenState();
}

class _SessionMapScreenState extends State<SessionMapScreen> {
  late Timer _timer;
  DateTime _now = DateTime.now().toUtc();

  final List<ForexSession> _sessions = [
    ForexSession(name: 'Sydney', startHour: 22, endHour: 7, color: Colors.blue),
    ForexSession(name: 'Tokyo', startHour: 0, endHour: 9, color: Colors.red),
    ForexSession(name: 'London', startHour: 8, endHour: 17, color: Colors.green),
    ForexSession(name: 'New York', startHour: 13, endHour: 22, color: Colors.orange),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now().toUtc();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localTime = _now.toLocal();
    final timeFormat = DateFormat.Hm();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Sessions'),
      ),
      body: Column(
        children: [
          // Time Display
          Container(
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('UTC Time', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      timeFormat.format(_now),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                Container(width: 1, height: 50, color: Colors.grey),
                Column(
                  children: [
                    const Text('Local Time', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      timeFormat.format(localTime),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // Sessions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                final session = _sessions[index];
                final isOpen = session.isOpen(_now);
                final progress = session.progress(_now);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: isOpen ? 4 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: isOpen 
                        ? BorderSide(color: session.color, width: 2) 
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled,
                                  color: isOpen ? session.color : Colors.grey,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  session.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isOpen ? null : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isOpen ? session.color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isOpen ? 'OPEN' : 'CLOSED',
                                style: TextStyle(
                                  color: isOpen ? session.color : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${session.startHour.toString().padLeft(2, '0')}:00 UTC',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '${session.endHour.toString().padLeft(2, '0')}:00 UTC',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation(session.color),
                            minHeight: 8,
                          ),
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
}

class ForexSession {
  final String name;
  final int startHour;
  final int endHour;
  final Color color;

  ForexSession({
    required this.name,
    required this.startHour,
    required this.endHour,
    required this.color,
  });

  bool isOpen(DateTime utcTime) {
    final currentHour = utcTime.hour + (utcTime.minute / 60.0);
    
    if (startHour < endHour) {
      return currentHour >= startHour && currentHour < endHour;
    } else {
      // Crosses midnight (e.g., Sydney 22:00 - 07:00)
      return currentHour >= startHour || currentHour < endHour;
    }
  }

  double progress(DateTime utcTime) {
    if (!isOpen(utcTime)) return 0.0;

    final currentHour = utcTime.hour + (utcTime.minute / 60.0);
    double duration;
    double elapsed;

    if (startHour < endHour) {
      duration = (endHour - startHour).toDouble();
      elapsed = currentHour - startHour;
    } else {
      duration = (24 - startHour) + endHour.toDouble();
      if (currentHour >= startHour) {
        elapsed = currentHour - startHour;
      } else {
        elapsed = (24 - startHour) + currentHour;
      }
    }

    return (elapsed / duration).clamp(0.0, 1.0);
  }
}