import 'package:hive/hive.dart';

part 'study_reminder.g.dart';

@HiveType(typeId: 15)
enum ReminderType {
  @HiveField(0)
  studySession,
  @HiveField(1)
  examPreparation,
  @HiveField(2)
  breakTime,
  @HiveField(3)
  assignmentDue,
  @HiveField(4)
  health,
}

@HiveType(typeId: 16)
enum ReminderPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
  @HiveField(3)
  urgent,
}

@HiveType(typeId: 17)
class StudyReminder {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ReminderType type;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String message;

  @HiveField(4)
  final DateTime scheduledTime;

  @HiveField(5)
  final ReminderPriority priority;

  @HiveField(6)
  final bool recurring;

  @HiveField(7)
  final String? recurringPattern;

  @HiveField(8)
  final bool completed;

  @HiveField(9)
  final bool dismissed;

  StudyReminder({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.scheduledTime,
    this.priority = ReminderPriority.medium,
    this.recurring = false,
    this.recurringPattern,
    this.completed = false,
    this.dismissed = false,
  });

  StudyReminder copyWith({
    String? id,
    ReminderType? type,
    String? title,
    String? message,
    DateTime? scheduledTime,
    ReminderPriority? priority,
    bool? recurring,
    String? recurringPattern,
    bool? completed,
    bool? dismissed,
  }) {
    return StudyReminder(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      priority: priority ?? this.priority,
      recurring: recurring ?? this.recurring,
      recurringPattern: recurringPattern ?? this.recurringPattern,
      completed: completed ?? this.completed,
      dismissed: dismissed ?? this.dismissed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'message': message,
      'scheduledTime': scheduledTime.toIso8601String(),
      'priority': priority.name,
      'recurring': recurring,
      'recurringPattern': recurringPattern,
      'completed': completed,
      'dismissed': dismissed,
    };
  }

  factory StudyReminder.fromMap(Map<String, dynamic> map) {
    return StudyReminder(
      id: map['id'],
      type: ReminderType.values.firstWhere((e) => e.name == map['type']),
      title: map['title'],
      message: map['message'],
      scheduledTime: DateTime.parse(map['scheduledTime']),
      priority: ReminderPriority.values.firstWhere((e) => e.name == map['priority']),
      recurring: map['recurring'] ?? false,
      recurringPattern: map['recurringPattern'],
      completed: map['completed'] ?? false,
      dismissed: map['dismissed'] ?? false,
    );
  }

  bool get isOverdue => DateTime.now().isAfter(scheduledTime) && !completed && !dismissed;
}
