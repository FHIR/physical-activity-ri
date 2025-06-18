// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_plan_form_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarePlanTableDataAdapter extends TypeAdapter<CarePlanTableData> {
  @override
  final int typeId = 14;

  @override
  CarePlanTableData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarePlanTableData(
      carePlanId: fields[0] as String?,
      text: fields[1] as String?,
      statusDropDown: fields[2] as String?,
      status: fields[3] as String?,
      startDate: fields[4] as DateTime?,
      endDate: fields[5] as DateTime?,
      goal: fields[6] as String?,
      patientId: fields[10] as String?,
    )
      ..isSync = fields[7] as bool
      ..readOnly = fields[8] as bool
      ..isDelete = fields[9] as bool
      ..goalObjectId = (fields[11] as List?)?.cast<String>()
      ..providerId = fields[12] as String
      ..qrUrl = fields[13] as String
      ..token = fields[14] as String
      ..clientId = fields[15] as String
      ..patientName = fields[16] as String
      ..providerName = fields[17] as String;
  }

  @override
  void write(BinaryWriter writer, CarePlanTableData obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.carePlanId)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.statusDropDown)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.goal)
      ..writeByte(7)
      ..write(obj.isSync)
      ..writeByte(8)
      ..write(obj.readOnly)
      ..writeByte(9)
      ..write(obj.isDelete)
      ..writeByte(10)
      ..write(obj.patientId)
      ..writeByte(11)
      ..write(obj.goalObjectId)
      ..writeByte(12)
      ..write(obj.providerId)
      ..writeByte(13)
      ..write(obj.qrUrl)
      ..writeByte(14)
      ..write(obj.token)
      ..writeByte(15)
      ..write(obj.clientId)
      ..writeByte(16)
      ..write(obj.patientName)
      ..writeByte(17)
      ..write(obj.providerName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarePlanTableDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
