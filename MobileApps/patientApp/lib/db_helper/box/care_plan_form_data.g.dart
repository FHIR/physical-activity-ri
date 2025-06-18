// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_plan_form_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarePlanTableDataAdapter extends TypeAdapter<CarePlanTableData> {
  @override
  final int typeId = 2;

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
      ..qrUrl = fields[12] as String
      ..token = fields[13] as String
      ..clientId = fields[14] as String
      ..patientName = fields[24] as String;
  }

  @override
  void write(BinaryWriter writer, CarePlanTableData obj) {
    writer
      ..writeByte(16)
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
      ..write(obj.qrUrl)
      ..writeByte(13)
      ..write(obj.token)
      ..writeByte(14)
      ..write(obj.clientId)
      ..writeByte(24)
      ..write(obj.patientName);
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
