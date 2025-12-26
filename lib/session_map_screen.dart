import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/services/session_service.dart';

class SessionMapScreen extends StatefulWidget {
  const SessionMapScreen({super.key});

  @override
  State<SessionMapScreen> createState() => _SessionMapScreenState();
}

class _SessionMapScreenState extends State<SessionMapScreen> {
  final SessionService _service = SessionService();
  late DateTime _nowUtc;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        _nowUtc = DateTime.now().toUtc();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Color _getSessionColor(String name) {
    switch (name) {
      case 'Sydney':
        return Colors.blue;
      case 'Tokyo':
        return Colors.purple;
      case 'London':
        return Colors.orange;
      case 'New York':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm:ss');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Sessions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Time Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'Current Time (UTC)',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timeFormat.format(_nowUtc),
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Major Markets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _service.sessions.length,
                itemBuilder: (context, index) {
                  final session = _service.sessions[index];
                  final isOpen = session.isOpen(_nowUtc);
                  final color = _getSessionColor(session.name);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      side: isOpen
                          ? BorderSide(color: color, width: 2)
                          : BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.2),
                        child: Icon(
                          Icons.access_time,
                          color: color,
                        ),
                      ),
                      title: Text(
                        session.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(session.timeRange),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isOpen ? color : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          isOpen ? 'OPEN' : 'CLOSED',
                          style: TextStyle(
                            color: isOpen ? Colors.white : Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}