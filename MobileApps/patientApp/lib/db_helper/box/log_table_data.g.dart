// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_table_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogTableDataAdapter extends TypeAdapter<LogTableData> {
  @override
  final int typeId = 6;

  @override
  LogTableData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LogTableData(
      resourceType: fields[0] as String?,
      type: fields[1] as String?,
      response: fields[2] as String?,
      patientId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LogTableData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.resourceType)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.response)
      ..writeByte(3)
      ..write(obj.patientId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogTableDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
