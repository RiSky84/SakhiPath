import 'package:hive/hive.dart';

part 'screen_time_session.g.dart';

@HiveType(typeId: 13)
enum AppCategory {
  @HiveField(0)
  distraction,
  @HiveField(1)
  productive,
  @HiveField(2)
  neutral,
}

@HiveType(typeId: 14)
class ScreenTimeSession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String appName;

  @HiveField(2)
  final AppCategory category;

  @HiveField(3)
  final DateTime startTime;

  @HiveField(4)
  final DateTime? endTime;

  @HiveField(5)
  final int durationMinutes;

  @HiveField(6)
  final int limitMinutes;

  @HiveField(7)
  final bool limitExceeded;

  ScreenTimeSession({
    required this.id,
    required this.appName,
    required this.category,
    required this.startTime,
    this.endTime,
    this.durationMinutes = 0,
    this.limitMinutes = 30,
    this.limitExceeded = false,
  });

  ScreenTimeSession copyWith({
    String? id,
    String? appName,
    AppCategory? category,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    int? limitMinutes,
    bool? limitExceeded,
  }) {
    return ScreenTimeSession(
      id: id ?? this.id,
      appName: appName ?? this.appName,
      category: category ?? this.category,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      limitMinutes: limitMinutes ?? this.limitMinutes,
      limitExceeded: limitExceeded ?? this.limitExceeded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'appName': appName,
      'category': category.name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'durationMinutes': durationMinutes,
      'limitMinutes': limitMinutes,
      'limitExceeded': limitExceeded,
    };
  }

  factory ScreenTimeSession.fromMap(Map<String, dynamic> map) {
    return ScreenTimeSession(
      id: map['id'],
      appName: map['appName'],
      category: AppCategory.values.firstWhere((e) => e.name == map['category']),
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      durationMinutes: map['durationMinutes'] ?? 0,
      limitMinutes: map['limitMinutes'] ?? 30,
      limitExceeded: map['limitExceeded'] ?? false,
    );
  }

  double get percentageUsed => (durationMinutes / limitMinutes) * 100;

  bool get isNearLimit => percentageUsed >= 80;
}
