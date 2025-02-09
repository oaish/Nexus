// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_slot_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubSlotModelAdapter extends TypeAdapter<SubSlotModel> {
  @override
  final int typeId = 0;

  @override
  SubSlotModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubSlotModel(
      subject: fields[0] as String?,
      teacher: fields[1] as String?,
      location: fields[2] as String?,
      activity: fields[3] as String?,
      batch: fields[4] as String?,
      group: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubSlotModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.subject)
      ..writeByte(1)
      ..write(obj.teacher)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.activity)
      ..writeByte(4)
      ..write(obj.batch)
      ..writeByte(5)
      ..write(obj.group);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubSlotModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
