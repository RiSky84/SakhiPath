
part of 'focus_mode.dart';

class FocusModeAdapter extends TypeAdapter<FocusMode> {
  @override
  final int typeId = 19;

  @override
  FocusMode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FocusMode(
      id: fields[0] as String,
      level: fields[1] as FocusLevel,
      startTime: fields[2] as DateTime?,
      endTime: fields[3] as DateTime?,
      durationMinutes: fields[4] as int?,
      blockedApps: (fields[5] as List).cast<String>(),
      allowedApps: (fields[6] as List).cast<String>(),
      isActive: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FocusMode obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.durationMinutes)
      ..writeByte(5)
      ..write(obj.blockedApps)
      ..writeByte(6)
      ..write(obj.allowedApps)
      ..writeByte(7)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FocusLevelAdapter extends TypeAdapter<FocusLevel> {
  @override
  final int typeId = 18;

  @override
  FocusLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FocusLevel.off;
      case 1:
        return FocusLevel.light;
      case 2:
        return FocusLevel.medium;
      case 3:
        return FocusLevel.strict;
      case 4:
        return FocusLevel.exam;
      default:
        return FocusLevel.off;
    }
  }

  @override
  void write(BinaryWriter writer, FocusLevel obj) {
    switch (obj) {
      case FocusLevel.off:
        writer.writeByte(0);
        break;
      case FocusLevel.light:
        writer.writeByte(1);
        break;
      case FocusLevel.medium:
        writer.writeByte(2);
        break;
      case FocusLevel.strict:
        writer.writeByte(3);
        break;
      case FocusLevel.exam:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
