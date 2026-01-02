import 'package:hive/hive.dart';

part 'focus_mode.g.dart';

@HiveType(typeId: 18)
enum FocusLevel {
  @HiveField(0)
  off,
  @HiveField(1)
  light,
  @HiveField(2)
  medium,
  @HiveField(3)
  strict,
  @HiveField(4)
  exam,
}

@HiveType(typeId: 19)
class FocusMode {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final FocusLevel level;

  @HiveField(2)
  final DateTime? startTime;

  @HiveField(3)
  final DateTime? endTime;

  @HiveField(4)
  final int? durationMinutes;

  @HiveField(5)
  final List<String> blockedApps;

  @HiveField(6)
  final List<String> allowedApps;

  @HiveField(7)
  final bool isActive;

  FocusMode({
    required this.id,
    required this.level,
    this.startTime,
    this.endTime,
    this.durationMinutes,
    this.blockedApps = const [],
    this.allowedApps = const [],
    this.isActive = false,
  });

  FocusMode copyWith({
    String? id,
    FocusLevel? level,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    List<String>? blockedApps,
    List<String>? allowedApps,
    bool? isActive,
  }) {
    return FocusMode(
      id: id ?? this.id,
      level: level ?? this.level,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      blockedApps: blockedApps ?? this.blockedApps,
      allowedApps: allowedApps ?? this.allowedApps,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level.name,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'durationMinutes': durationMinutes,
      'blockedApps': blockedApps,
      'allowedApps': allowedApps,
      'isActive': isActive,
    };
  }

  factory FocusMode.fromMap(Map<String, dynamic> map) {
    return FocusMode(
      id: map['id'],
      level: FocusLevel.values.firstWhere((e) => e.name == map['level']),
      startTime: map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      durationMinutes: map['durationMinutes'],
      blockedApps: List<String>.from(map['blockedApps'] ?? []),
      allowedApps: List<String>.from(map['allowedApps'] ?? []),
      isActive: map['isActive'] ?? false,
    );
  }

  static List<String> getDefaultBlockedApps(FocusLevel level) {
    switch (level) {
      case FocusLevel.light:
        return ['Instagram', 'TikTok', 'Snapchat'];
      case FocusLevel.medium:
        return ['Instagram', 'TikTok', 'Snapchat', 'YouTube', 'Facebook', 'Twitter'];
      case FocusLevel.strict:
        return [
          'Instagram', 'TikTok', 'Snapchat', 'YouTube', 'Facebook', 'Twitter',
          'Reddit', 'Netflix', 'Prime Video', 'WhatsApp', 'Telegram'
        ];
      case FocusLevel.exam:
        return [
          'Instagram', 'TikTok', 'Snapchat', 'YouTube', 'Facebook', 'Twitter',
          'Reddit', 'Netflix', 'Prime Video', 'WhatsApp', 'Telegram',
          'Games', 'Entertainment'
        ];
      default:
        return [];
    }
  }

  static List<String> getDefaultAllowedApps(FocusLevel level) {
    if (level == FocusLevel.exam || level == FocusLevel.strict) {
      return [
        'Khan Academy', 'Duolingo', 'Quizlet', 'Google Classroom',
        'Microsoft Teams', 'Zoom', 'SakhiPath'
      ];
    }
    return [];
  }
}
