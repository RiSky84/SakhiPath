
part of 'study_reminder.dart';

class StudyReminderAdapter extends TypeAdapter<StudyReminder> {
  @override
  final int typeId = 17;

  @override
  StudyReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyReminder(
      id: fields[0] as String,
      type: fields[1] as ReminderType,
      title: fields[2] as String,
      message: fields[3] as String,
      scheduledTime: fields[4] as DateTime,
      priority: fields[5] as ReminderPriority,
      recurring: fields[6] as bool,
      recurringPattern: fields[7] as String?,
      completed: fields[8] as bool,
      dismissed: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StudyReminder obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.scheduledTime)
      ..writeByte(5)
      ..write(obj.priority)
      ..writeByte(6)
      ..write(obj.recurring)
      ..writeByte(7)
      ..write(obj.recurringPattern)
      ..writeByte(8)
      ..write(obj.completed)
      ..writeByte(9)
      ..write(obj.dismissed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderTypeAdapter extends TypeAdapter<ReminderType> {
  @override
  final int typeId = 15;

  @override
  ReminderType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReminderType.studySession;
      case 1:
        return ReminderType.examPreparation;
      case 2:
        return ReminderType.breakTime;
      case 3:
        return ReminderType.assignmentDue;
      case 4:
        return ReminderType.health;
      default:
        return ReminderType.studySession;
    }
  }

  @override
  void write(BinaryWriter writer, ReminderType obj) {
    switch (obj) {
      case ReminderType.studySession:
        writer.writeByte(0);
        break;
      case ReminderType.examPreparation:
        writer.writeByte(1);
        break;
      case ReminderType.breakTime:
        writer.writeByte(2);
        break;
      case ReminderType.assignmentDue:
        writer.writeByte(3);
        break;
      case ReminderType.health:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReminderPriorityAdapter extends TypeAdapter<ReminderPriority> {
  @override
  final int typeId = 16;

  @override
  ReminderPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReminderPriority.low;
      case 1:
        return ReminderPriority.medium;
      case 2:
        return ReminderPriority.high;
      case 3:
        return ReminderPriority.urgent;
      default:
        return ReminderPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, ReminderPriority obj) {
    switch (obj) {
      case ReminderPriority.low:
        writer.writeByte(0);
        break;
      case ReminderPriority.medium:
        writer.writeByte(1);
        break;
      case ReminderPriority.high:
        writer.writeByte(2);
        break;
      case ReminderPriority.urgent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
