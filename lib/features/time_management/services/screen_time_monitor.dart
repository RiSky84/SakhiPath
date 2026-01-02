import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/screen_time_session.dart';

final screenTimeMonitorProvider = Provider((ref) => ScreenTimeMonitor());

class ScreenTimeMonitor {
  late Box<ScreenTimeSession> _sessionsBox;
  final _uuid = const Uuid();

  static const Map<String, int> defaultLimits = {
    'Instagram': 30,
    'TikTok': 30,
    'YouTube Shorts': 30,
    'Snapchat': 30,
    'Facebook': 30,
    'Twitter': 30,
    'Reddit': 30,
  };

  static const List<String> productiveApps = [
    'Khan Academy',
    'Duolingo',
    'Quizlet',
    'Google Classroom',
    'SakhiPath',
  ];

  Future<void> initialize() async {
    _sessionsBox = await Hive.openBox<ScreenTimeSession>('screen_time_sessions');
  }

  Future<ScreenTimeSession> startTracking(String appName) async {
    final category = _getAppCategory(appName);
    final limit = defaultLimits[appName] ?? 60;

    final session = ScreenTimeSession(
      id: _uuid.v4(),
      appName: appName,
      category: category,
      startTime: DateTime.now(),
      limitMinutes: limit,
    );

    await _sessionsBox.put(session.id, session);
    return session;
  }

  Future<ScreenTimeSession> endTracking(String sessionId) async {
    final session = _sessionsBox.get(sessionId);
    if (session == null) {
      throw Exception('Session not found');
    }

    final now = DateTime.now();
    final duration = now.difference(session.startTime).inMinutes;
    final exceeded = duration > session.limitMinutes;

    final updatedSession = session.copyWith(
      endTime: now,
      durationMinutes: duration,
      limitExceeded: exceeded,
    );

    await _sessionsBox.put(sessionId, updatedSession);
    return updatedSession;
  }

  int getTodayUsage(String appName) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todaySessions = _sessionsBox.values
        .where((session) =>
            session.appName == appName && session.startTime.isAfter(today))
        .toList();

    return todaySessions.fold<int>(
      0,
      (sum, session) => sum + session.durationMinutes,
    );
  }

  bool isLimitExceeded(String appName) {
    final todayUsage = getTodayUsage(appName);
    final limit = defaultLimits[appName] ?? 60;
    return todayUsage >= limit;
  }

  int getRemainingTime(String appName) {
    final todayUsage = getTodayUsage(appName);
    final limit = defaultLimits[appName] ?? 60;
    return limit - todayUsage;
  }

  Map<String, dynamic> getDailySummary() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todaySessions = _sessionsBox.values
        .where((session) => session.startTime.isAfter(today))
        .toList();

    final distractionTime = todaySessions
        .where((s) => s.category == AppCategory.distraction)
        .fold<int>(0, (sum, s) => sum + s.durationMinutes);

    final productiveTime = todaySessions
        .where((s) => s.category == AppCategory.productive)
        .fold<int>(0, (sum, s) => sum + s.durationMinutes);

    final appBreakdown = <String, int>{};
    for (final session in todaySessions) {
      appBreakdown[session.appName] =
          (appBreakdown[session.appName] ?? 0) + session.durationMinutes;
    }

    return {
      'distractionMinutes': distractionTime,
      'productiveMinutes': productiveTime,
      'totalMinutes': distractionTime + productiveTime,
      'appBreakdown': appBreakdown,
      'sessions': todaySessions,
    };
  }

  AppCategory _getAppCategory(String appName) {
    if (defaultLimits.containsKey(appName)) {
      return AppCategory.distraction;
    } else if (productiveApps.contains(appName)) {
      return AppCategory.productive;
    }
    return AppCategory.neutral;
  }

  List<MapEntry<String, int>> getMostUsedAppsToday() {
    final summary = getDailySummary();
    final breakdown = summary['appBreakdown'] as Map<String, int>;

    final entries = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return entries;
  }

  bool isReelsTimeExcessive() {
    final reelsApps = ['Instagram', 'TikTok', 'YouTube Shorts', 'Snapchat'];
    var totalReelsTime = 0;

    for (final app in reelsApps) {
      totalReelsTime += getTodayUsage(app);
    }

    return totalReelsTime > 60;
  }

  int getProductivityScore() {
    final summary = getDailySummary();
    final distractionTime = summary['distractionMinutes'] as int;
    final productiveTime = summary['productiveMinutes'] as int;
    final totalTime = distractionTime + productiveTime;

    if (totalTime == 0) return 100;

    final score = ((productiveTime / totalTime) * 100).toInt();
    return score;
  }

  ScreenTimeSession? getActiveSession() {
    return _sessionsBox.values
        .where((session) => session.endTime == null)
        .firstOrNull;
  }

  Future<void> clearAllSessions() async {
    await _sessionsBox.clear();
  }
}
