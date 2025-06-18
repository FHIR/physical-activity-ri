// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_form_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToDoTableDataAdapter extends TypeAdapter<ToDoTableData> {
  @override
  final int typeId = 99;

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
      ..isCreated = fields[8] as bool?
      ..businessStatus = fields[9] as String?
      ..providerId = fields[10] as String
      ..forReference = fields[11] as String
      ..forDisplay = fields[12] as String
      ..requesterReference = fields[13] as String
      ..requesterDisplay = fields[14] as String
      ..ownerReference = fields[15] as String
      ..ownerDisplay = fields[16] as String
      ..tag = fields[17] as String
      ..lastUpdatedDate = fields[18] as DateTime?
      ..createdDate = fields[19] as DateTime?
      ..needDisplay = fields[20] as bool
      ..text = fields[21] as String
      ..focusReference = fields[22] as String
      ..qrUrl = fields[23] as String
      ..token = fields[24] as String
      ..clientId = fields[25] as String
      ..patientName = fields[26] as String
      ..providerName = fields[27] as String;
  }

  @override
  void write(BinaryWriter writer, ToDoTableData obj) {
    writer
      ..writeByte(28)
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
      ..write(obj.isCreated)
      ..writeByte(9)
      ..write(obj.businessStatus)
      ..writeByte(10)
      ..write(obj.providerId)
      ..writeByte(11)
      ..write(obj.forReference)
      ..writeByte(12)
      ..write(obj.forDisplay)
      ..writeByte(13)
      ..write(obj.requesterReference)
      ..writeByte(14)
      ..write(obj.requesterDisplay)
      ..writeByte(15)
      ..write(obj.ownerReference)
      ..writeByte(16)
      ..write(obj.ownerDisplay)
      ..writeByte(17)
      ..write(obj.tag)
      ..writeByte(18)
      ..write(obj.lastUpdatedDate)
      ..writeByte(19)
      ..write(obj.createdDate)
      ..writeByte(20)
      ..write(obj.needDisplay)
      ..writeByte(21)
      ..write(obj.text)
      ..writeByte(22)
      ..write(obj.focusReference)
      ..writeByte(23)
      ..write(obj.qrUrl)
      ..writeByte(24)
      ..write(obj.token)
      ..writeByte(25)
      ..write(obj.clientId)
      ..writeByte(26)
      ..write(obj.patientName)
      ..writeByte(27)
      ..write(obj.providerName);
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
