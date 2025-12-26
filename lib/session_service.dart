class SessionInfo {
  final String name;
  final int startHourUtc;
  final int endHourUtc;

  const SessionInfo({
    required this.name,
    required this.startHourUtc,
    required this.endHourUtc,
  });

  bool isOpen(DateTime nowUtc) {
    final currentHour = nowUtc.hour;

    if (startHourUtc > endHourUtc) {
      // Crosses midnight (e.g., Sydney 21:00 - 06:00)
      return currentHour >= startHourUtc || currentHour < endHourUtc;
    } else {
      // Standard day range (e.g., London 07:00 - 16:00)
      return currentHour >= startHourUtc && currentHour < endHourUtc;
    }
  }

  String get timeRange =>
      '${startHourUtc.toString().padLeft(2, '0')}:00 - ${endHourUtc.toString().padLeft(2, '0')}:00 UTC';
}

class SessionService {
  // Standard Forex Market Hours in UTC (approximate, ignoring DST variations for simplicity)
  final List<SessionInfo> sessions = const [
    SessionInfo(name: 'Sydney', startHourUtc: 21, endHourUtc: 6),
    SessionInfo(name: 'Tokyo', startHourUtc: 0, endHourUtc: 9),
    SessionInfo(name: 'London', startHourUtc: 7, endHourUtc: 16),
    SessionInfo(name: 'New York', startHourUtc: 12, endHourUtc: 21),
  ];

  List<SessionInfo> getOpenSessions(DateTime nowUtc) {
    return sessions.where((s) => s.isOpen(nowUtc)).toList();
  }
}