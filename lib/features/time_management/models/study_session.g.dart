
part of 'study_session.dart';

class StudySessionAdapter extends TypeAdapter<StudySession> {
  @override
  final int typeId = 12;

  @override
  StudySession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudySession(
      id: fields[0] as String,
      type: fields[1] as SessionType,
      subject: fields[2] as SubjectCategory,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime?,
      durationMinutes: fields[5] as int,
      notes: fields[6] as String?,
      productivityScore: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StudySession obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.subject)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.durationMinutes)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.productivityScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudySessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionTypeAdapter extends TypeAdapter<SessionType> {
  @override
  final int typeId = 10;

  @override
  SessionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SessionType.focusedStudy;
      case 1:
        return SessionType.pomodoro;
      case 2:
        return SessionType.review;
      case 3:
        return SessionType.groupStudy;
      default:
        return SessionType.focusedStudy;
    }
  }

  @override
  void write(BinaryWriter writer, SessionType obj) {
    switch (obj) {
      case SessionType.focusedStudy:
        writer.writeByte(0);
        break;
      case SessionType.pomodoro:
        writer.writeByte(1);
        break;
      case SessionType.review:
        writer.writeByte(2);
        break;
      case SessionType.groupStudy:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectCategoryAdapter extends TypeAdapter<SubjectCategory> {
  @override
  final int typeId = 11;

  @override
  SubjectCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubjectCategory.mathematics;
      case 1:
        return SubjectCategory.science;
      case 2:
        return SubjectCategory.languages;
      case 3:
        return SubjectCategory.socialStudies;
      case 4:
        return SubjectCategory.computerScience;
      case 5:
        return SubjectCategory.arts;
      case 6:
        return SubjectCategory.other;
      default:
        return SubjectCategory.mathematics;
    }
  }

  @override
  void write(BinaryWriter writer, SubjectCategory obj) {
    switch (obj) {
      case SubjectCategory.mathematics:
        writer.writeByte(0);
        break;
      case SubjectCategory.science:
        writer.writeByte(1);
        break;
      case SubjectCategory.languages:
        writer.writeByte(2);
        break;
      case SubjectCategory.socialStudies:
        writer.writeByte(3);
        break;
      case SubjectCategory.computerScience:
        writer.writeByte(4);
        break;
      case SubjectCategory.arts:
        writer.writeByte(5);
        break;
      case SubjectCategory.other:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
