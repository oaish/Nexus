// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_slot_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeTableSlotModelAdapter extends TypeAdapter<TimeTableSlotModel> {
  @override
  final int typeId = 1;

  @override
  TimeTableSlotModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeTableSlotModel(
      sTime: fields[0] as String,
      eTime: fields[1] as String,
      subject: fields[2] as String?,
      teacher: fields[3] as String?,
      location: fields[4] as String?,
      activity: fields[5] as String?,
      type: fields[6] as String?,
      subSlots: (fields[7] as List?)?.cast<SubSlotModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, TimeTableSlotModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.sTime)
      ..writeByte(1)
      ..write(obj.eTime)
      ..writeByte(2)
      ..write(obj.subject)
      ..writeByte(3)
      ..write(obj.teacher)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.activity)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.subSlots);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeTableSlotModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
