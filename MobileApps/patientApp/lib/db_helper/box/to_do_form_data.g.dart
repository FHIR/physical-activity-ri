// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_form_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToDoTableDataAdapter extends TypeAdapter<ToDoTableData> {
  @override
  final int typeId = 14;

  @override
  ToDoTableData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDoTableData(
      objectId: fields[0] as String?,
      status: fields[1] as String?,
      statusReason: fields[2] as String?,
      patientId: fields[3] as String?,
      priority: fields[5] as String?,
      code: fields[6] as String?,
    )
      ..isSync = fields[4] as bool
      ..display = fields[7] as String?
      ..qrUrl = fields[8] as String
      ..token = fields[9] as String
      ..clientId = fields[10] as String
      ..patientName = fields[11] as String
      ..forReference = fields[12] as String
      ..forDisplay = fields[13] as String
      ..requesterReference = fields[14] as String
      ..requesterDisplay = fields[15] as String
      ..ownerReference = fields[16] as String
      ..ownerDisplay = fields[17] as String
      ..tag = fields[18] as String
      ..lastUpdatedDate = fields[19] as DateTime?
      ..createdDate = fields[20] as DateTime?
      ..businessStatus = fields[21] as String?;
  }

  @override
  void write(BinaryWriter writer, ToDoTableData obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.statusReason)
      ..writeByte(3)
      ..write(obj.patientId)
      ..writeByte(4)
      ..write(obj.isSync)
      ..writeByte(5)
      ..write(obj.priority)
      ..writeByte(6)
      ..write(obj.code)
      ..writeByte(7)
      ..write(obj.display)
      ..writeByte(8)
      ..write(obj.qrUrl)
      ..writeByte(9)
      ..write(obj.token)
      ..writeByte(10)
      ..write(obj.clientId)
      ..writeByte(11)
      ..write(obj.patientName)
      ..writeByte(12)
      ..write(obj.forReference)
      ..writeByte(13)
      ..write(obj.forDisplay)
      ..writeByte(14)
      ..write(obj.requesterReference)
      ..writeByte(15)
      ..write(obj.requesterDisplay)
      ..writeByte(16)
      ..write(obj.ownerReference)
      ..writeByte(17)
      ..write(obj.ownerDisplay)
      ..writeByte(18)
      ..write(obj.tag)
      ..writeByte(19)
      ..write(obj.lastUpdatedDate)
      ..writeByte(20)
      ..write(obj.createdDate)
      ..writeByte(21)
      ..write(obj.businessStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToDoTableDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
