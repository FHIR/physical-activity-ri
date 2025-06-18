// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteTableDataAdapter extends TypeAdapter<NoteTableData> {
  @override
  final int typeId = 8;

  @override
  NoteTableData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteTableData(
      author: fields[0] as String?,
      date: fields[1] as DateTime?,
      notes: fields[2] as String?,
      patientId: fields[9] as String?,
    )
      ..readOnly = fields[3] as bool
      ..isDelete = fields[4] as bool
      ..goalId = fields[5] as int?
      ..referralId = fields[6] as int?
      ..routingId = fields[7] as int?
      ..carePlanId = fields[8] as int?
      ..referralTaskId = fields[10] as String?
      ..TaskId = fields[11] as int?
      ..isCreatedNote = fields[12] as bool?
      ..isAssignedNote = fields[13] as bool?
      ..isTaskNote = fields[14] as bool?;
  }

  @override
  void write(BinaryWriter writer, NoteTableData obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.author)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.readOnly)
      ..writeByte(4)
      ..write(obj.isDelete)
      ..writeByte(5)
      ..write(obj.goalId)
      ..writeByte(6)
      ..write(obj.referralId)
      ..writeByte(7)
      ..write(obj.routingId)
      ..writeByte(8)
      ..write(obj.carePlanId)
      ..writeByte(9)
      ..write(obj.patientId)
      ..writeByte(10)
      ..write(obj.referralTaskId)
      ..writeByte(11)
      ..write(obj.TaskId)
      ..writeByte(12)
      ..write(obj.isCreatedNote)
      ..writeByte(13)
      ..write(obj.isAssignedNote)
      ..writeByte(14)
      ..write(obj.isTaskNote);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteTableDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
