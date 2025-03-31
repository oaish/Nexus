// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeTableModelAdapter extends TypeAdapter<TimeTableModel> {
  @override
  final int typeId = 2;

  @override
  TimeTableModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeTableModel(
      id: fields[0] as String,
      name: fields[1] as String,
      userId: fields[2] as String,
      lastModified: fields[3] as DateTime,
      schedule: (fields[4] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<TimeTableSlotModel>())),
      department: fields[5] as String,
      year: fields[6] as String,
      division: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TimeTableModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.lastModified)
      ..writeByte(4)
      ..write(obj.schedule)
      ..writeByte(5)
      ..write(obj.department)
      ..writeByte(6)
      ..write(obj.year)
      ..writeByte(7)
      ..write(obj.division);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeTableModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
