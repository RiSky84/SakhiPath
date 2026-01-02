import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/study_session.dart';

final studyTimeTrackerProvider = Provider((ref) => StudyTimeTracker());

class StudyTimeTracker {
  late Box<StudySession> _sessionsBox;
  final _uuid = const Uuid();

  Future<void> initialize() async {
    _sessionsBox = await Hive.openBox<StudySession>('study_sessions');
  }

  Future<StudySession> startSession({
    required SessionType type,
    required SubjectCategory subject,
    String? notes,
  }) async {
    final session = StudySession(
      id: _uuid.v4(),
      type: type,
      subject: subject,
      startTime: DateTime.now(),
      notes: notes,
    );

    await _sessionsBox.put(session.id, session);
    return session;
  }

  Future<StudySession> endSession(String sessionId) async {
    final session = _sessionsBox.get(sessionId);
    if (session == null) {
      throw Exception('Session not found');
    }

    final now = DateTime.now();
    final duration = now.difference(session.startTime).inMinutes;

    final productivityScore = duration >= 25 ? 100 : (duration / 25 * 100).toInt();

    final updatedSession = session.copyWith(
      endTime: now,
      durationMinutes: duration,
      productivityScore: productivityScore,
    );

    await _sessionsBox.put(sessionId, updatedSession);
    return updatedSession;
  }

  List<StudySession> getAllSessions() {
    return _sessionsBox.values.toList();
  }

  List<StudySession> getTodaySessions() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _sessionsBox.values
        .where((session) => session.startTime.isAfter(today))
        .toList();
  }

  List<StudySession> getSessionsInRange(DateTime start, DateTime end) {
    return _sessionsBox.values
        .where((session) =>
            session.startTime.isAfter(start) &&
            session.startTime.isBefore(end))
        .toList();
  }

  Map<String, dynamic> getDailyStats() {
    final todaySessions = getTodaySessions();

    final totalMinutes = todaySessions.fold<int>(
      0,
      (sum, session) => sum + session.durationMinutes,
    );

    final completedSessions = todaySessions
        .where((session) => session.endTime != null)
        .length;

    final avgProductivity = todaySessions.isEmpty
        ? 0
        : todaySessions.fold<int>(
              0,
              (sum, session) => sum + session.productivityScore,
            ) ~/
            todaySessions.length;

    return {
      'totalMinutes': totalMinutes,
      'totalHours': (totalMinutes / 60).toStringAsFixed(1),
      'completedSessions': completedSessions,
      'averageProductivity': avgProductivity,
      'sessions': todaySessions,
    };
  }

  Map<String, dynamic> getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    final weeklySessions = getSessionsInRange(weekStart, weekEnd);

    final totalMinutes = weeklySessions.fold<int>(
      0,
      (sum, session) => sum + session.durationMinutes,
    );

    final subjectBreakdown = <SubjectCategory, int>{};
    for (final session in weeklySessions) {
      subjectBreakdown[session.subject] =
          (subjectBreakdown[session.subject] ?? 0) + session.durationMinutes;
    }

    return {
      'totalMinutes': totalMinutes,
      'totalHours': (totalMinutes / 60).toStringAsFixed(1),
      'sessionsCount': weeklySessions.length,
      'subjectBreakdown': subjectBreakdown,
      'sessions': weeklySessions,
    };
  }

  Map<SubjectCategory, int> getSubjectStats() {
    final allSessions = getAllSessions();
    final stats = <SubjectCategory, int>{};

    for (final session in allSessions) {
      stats[session.subject] =
          (stats[session.subject] ?? 0) + session.durationMinutes;
    }

    return stats;
  }

  Future<void> deleteSession(String sessionId) async {
    await _sessionsBox.delete(sessionId);
  }

  Future<void> clearAllSessions() async {
    await _sessionsBox.clear();
  }

  StudySession? getActiveSession() {
    return _sessionsBox.values
        .where((session) => session.endTime == null)
        .firstOrNull;
  }

  bool hasStudiedToday() {
    return getTodaySessions().isNotEmpty;
  }

  int getStudyStreak() {
    final sessions = getAllSessions()
        .where((s) => s.endTime != null)
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    if (sessions.isEmpty) return 0;

    var streak = 1;
    var currentDate = DateTime.now();
    var lastSessionDate = sessions.first.startTime;

    if (!_isSameDay(currentDate, lastSessionDate)) {

      if (!_isSameDay(currentDate.subtract(const Duration(days: 1)), lastSessionDate)) {
        return 0;
      }
    }

    for (var i = 0; i < sessions.length - 1; i++) {
      final currentSession = sessions[i];
      final nextSession = sessions[i + 1];

      final daysDifference = currentSession.startTime.difference(nextSession.startTime).inDays;

      if (daysDifference == 1) {
        streak++;
      } else if (daysDifference > 1) {
        break;
      }
    }

    return streak;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
