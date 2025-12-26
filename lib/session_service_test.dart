import 'package:flutter_test/flutter_test.dart';
import 'package:forex_companion/features/tools/domain/services/session_service.dart';

void main() {
  group('SessionService', () {
    late SessionService service;

    setUp(() {
      service = SessionService();
    });

    test('London session (07-16) status checks', () {
      final london = service.sessions.firstWhere((s) => s.name == 'London');

      // 10:00 UTC - Should be open
      final timeOpen = DateTime.utc(2023, 1, 1, 10, 0);
      expect(london.isOpen(timeOpen), isTrue);

      // 06:00 UTC - Should be closed
      final timeClosedBefore = DateTime.utc(2023, 1, 1, 6, 0);
      expect(london.isOpen(timeClosedBefore), isFalse);

      // 16:00 UTC - Should be closed (end hour is exclusive)
      final timeClosedAfter = DateTime.utc(2023, 1, 1, 16, 0);
      expect(london.isOpen(timeClosedAfter), isFalse);
    });

    test('Sydney session (21-06) status checks (cross-midnight)', () {
      final sydney = service.sessions.firstWhere((s) => s.name == 'Sydney');

      // 23:00 UTC - Should be open
      final timeOpenLate = DateTime.utc(2023, 1, 1, 23, 0);
      expect(sydney.isOpen(timeOpenLate), isTrue);

      // 02:00 UTC - Should be open
      final timeOpenEarly = DateTime.utc(2023, 1, 1, 2, 0);
      expect(sydney.isOpen(timeOpenEarly), isTrue);

      // 10:00 UTC - Should be closed
      final timeClosed = DateTime.utc(2023, 1, 1, 10, 0);
      expect(sydney.isOpen(timeClosed), isFalse);
    });

    test('getOpenSessions returns correct sessions for overlap (13:00 UTC)', () {
      // 13:00 UTC:
      // Sydney (21-06): Closed
      // Tokyo (00-09): Closed
      // London (07-16): Open
      // New York (12-21): Open
      
      final time = DateTime.utc(2023, 1, 1, 13, 0);
      final openSessions = service.getOpenSessions(time);
      
      final names = openSessions.map((s) => s.name).toList();
      expect(names, containsAll(['London', 'New York']));
      expect(names, isNot(contains('Sydney')));
      expect(names, isNot(contains('Tokyo')));
    });

    test('getOpenSessions returns correct sessions for 04:00 UTC', () {
      // 04:00 UTC:
      // Sydney (21-06): Open
      // Tokyo (00-09): Open
      // London (07-16): Closed
      // New York (12-21): Closed

      final time = DateTime.utc(2023, 1, 1, 4, 0);
      final openSessions = service.getOpenSessions(time);

      final names = openSessions.map((s) => s.name).toList();
      expect(names, containsAll(['Sydney', 'Tokyo']));
      expect(names, isNot(contains('London')));
      expect(names, isNot(contains('New York')));
    });
  });
}