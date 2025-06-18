// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_form_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConditionTableDataAdapter extends TypeAdapter<ConditionTableData> {
  @override
  final int typeId = 18;

  @override
  ConditionTableData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConditionTableData(
      conditionID: fields[0] as String?,
      verificationStatus: fields[1] as String?,
      onset: fields[2] as DateTime?,
      abatement: fields[3] as DateTime?,
      patientId: fields[7] as String?,
    )
      ..isSync = fields[4] as bool
      ..readOnly = fields[5] as bool
      ..isDelete = fields[6] as bool
      ..providerId = fields[8] as String
      ..code = fields[9] as String?
      ..display = fields[10] as String?
      ..text = fields[11] as String?
      ..qrUrl = fields[12] as String
      ..token = fields[13] as String
      ..clientId = fields[14] as String
      ..patientName = fields[15] as String
      ..providerName = fields[16] as String;
  }

  @override
  void write(BinaryWriter writer, ConditionTableData obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.conditionID)
      ..writeByte(1)
      ..write(obj.verificationStatus)
      ..writeByte(2)
      ..write(obj.onset)
      ..writeByte(3)
      ..write(obj.abatement)
      ..writeByte(4)
      ..write(obj.isSync)
      ..writeByte(5)
      ..write(obj.readOnly)
      ..writeByte(6)
      ..write(obj.isDelete)
      ..writeByte(7)
      ..write(obj.patientId)
      ..writeByte(8)
      ..write(obj.providerId)
      ..writeByte(9)
      ..write(obj.code)
      ..writeByte(10)
      ..write(obj.display)
      ..writeByte(11)
      ..write(obj.text)
      ..writeByte(12)
      ..write(obj.qrUrl)
      ..writeByte(13)
      ..write(obj.token)
      ..writeByte(14)
      ..write(obj.clientId)
      ..writeByte(15)
      ..write(obj.patientName)
      ..writeByte(16)
      ..write(obj.providerName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConditionTableDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
