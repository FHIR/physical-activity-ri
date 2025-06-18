// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalTableDataAdapter extends TypeAdapter<GoalTableData> {
  @override
  final int typeId = 4;

  @override
  GoalTableData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalTableData(
      goalId: fields[0] as String?,
      notes: fields[1] as String?,
      description: fields[2] as String?,
      target: fields[3] as String?,
      dueDate: fields[4] as DateTime?,
      lifeCycleStatus: fields[5] as String?,
      achievementStatus: fields[6] as String?,
      multipleGoals: fields[9] as String?,
      patientId: fields[17] as String?,
    )
      ..createdDate = fields[7] as DateTime?
      ..updatedDate = fields[8] as DateTime?
      ..objectId = fields[10] as String?
      ..isSync = fields[11] as bool
      ..readOnly = fields[12] as bool
      ..isDelete = fields[13] as bool
      ..code = fields[14] as String
      ..system = fields[15] as String
      ..actualDescription = fields[16] as String
      ..isEditable = fields[18] as bool
      ..expressedBy = fields[19] as String
      ..expressedByDisplay = fields[20] as String
      ..qrUrl = fields[21] as String
      ..token = fields[22] as String
      ..clientId = fields[23] as String
      ..patientName = fields[24] as String;
  }

  @override
  void write(BinaryWriter writer, GoalTableData obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.goalId)
      ..writeByte(1)
      ..write(obj.notes)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.target)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.lifeCycleStatus)
      ..writeByte(6)
      ..write(obj.achievementStatus)
      ..writeByte(7)
      ..write(obj.createdDate)
      ..writeByte(8)
      ..write(obj.updatedDate)
      ..writeByte(9)
      ..write(obj.multipleGoals)
      ..writeByte(10)
      ..write(obj.objectId)
      ..writeByte(11)
      ..write(obj.isSync)
      ..writeByte(12)
      ..write(obj.readOnly)
      ..writeByte(13)
      ..write(obj.isDelete)
      ..writeByte(14)
      ..write(obj.code)
      ..writeByte(15)
      ..write(obj.system)
      ..writeByte(16)
      ..write(obj.actualDescription)
      ..writeByte(17)
      ..write(obj.patientId)
      ..writeByte(18)
      ..write(obj.isEditable)
      ..writeByte(19)
      ..write(obj.expressedBy)
      ..writeByte(20)
      ..write(obj.expressedByDisplay)
      ..writeByte(21)
      ..write(obj.qrUrl)
      ..writeByte(22)
      ..write(obj.token)
      ..writeByte(23)
      ..write(obj.clientId)
      ..writeByte(24)
      ..write(obj.patientName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalTableDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
