import 'package:hive/hive.dart';

part 'study_session.g.dart';

@HiveType(typeId: 10)
enum SessionType {
  @HiveField(0)
  focusedStudy,
  @HiveField(1)
  pomodoro,
  @HiveField(2)
  review,
  @HiveField(3)
  groupStudy,
}

@HiveType(typeId: 11)
enum SubjectCategory {
  @HiveField(0)
  mathematics,
  @HiveField(1)
  science,
  @HiveField(2)
  languages,
  @HiveField(3)
  socialStudies,
  @HiveField(4)
  computerScience,
  @HiveField(5)
  arts,
  @HiveField(6)
  other,
}

@HiveType(typeId: 12)
class StudySession {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final SessionType type;

  @HiveField(2)
  final SubjectCategory subject;

  @HiveField(3)
  final DateTime startTime;

  @HiveField(4)
  final DateTime? endTime;

  @HiveField(5)
  final int durationMinutes;

  @HiveField(6)
  final String? notes;

  @HiveField(7)
  final int productivityScore;

  StudySession({
    required this.id,
    required this.type,
    required this.subject,
    required this.startTime,
    this.endTime,
    this.durationMinutes = 0,
    this.notes,
    this.productivityScore = 0,
  });

  StudySession copyWith({
    String? id,
    SessionType? type,
    SubjectCategory? subject,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    String? notes,
    int? productivityScore,
  }) {
    return StudySession(
      id: id ?? this.id,
      type: type ?? this.type,
      subject: subject ?? this.subject,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      productivityScore: productivityScore ?? this.productivityScore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'subject': subject.name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'durationMinutes': durationMinutes,
      'notes': notes,
      'productivityScore': productivityScore,
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      id: map['id'],
      type: SessionType.values.firstWhere((e) => e.name == map['type']),
      subject: SubjectCategory.values.firstWhere((e) => e.name == map['subject']),
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      durationMinutes: map['durationMinutes'] ?? 0,
      notes: map['notes'],
      productivityScore: map['productivityScore'] ?? 0,
    );
  }
}
