// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityTableAdapter extends TypeAdapter<ActivityTable> {
  @override
  final int typeId = 10;

  @override
  ActivityTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityTable(
      id: fields[0] as int?,
      name: fields[1] as String?,
      date: fields[2] as String?,
      title: fields[3] as String?,
      value1: fields[4] as double?,
      value2: fields[5] as double?,
      total: fields[6] as double?,
      type: fields[7] as int?,
      weeksDate: fields[8] as String?,
      patientId: fields[9] as String?,
      dateTime: fields[10] as DateTime?,
      displayLabel: fields[11] as String?,
      insertedDayDataId: fields[12] as int?,
      smileyType: fields[13] as int?,
      isCheckedDay: fields[14] as bool?,
      isCheckedDayData: fields[15] as bool?,
    )
      ..notes = fields[16] as String?
      ..isOverride = fields[17] as bool
      ..isSync = fields[18] as bool
      ..objectId = fields[19] as String
      ..iconPath = fields[20] as String
      ..needExport = fields[21] as bool
      ..providerId = fields[22] as String
      ..expreianceIconValue = fields[23] as double?
      ..serverDetailList = (fields[24] as List).cast<ServerDetailDataTable>()
      ..identifierData = (fields[25] as List).cast<IdentifierTable>()
      ..activityStartDate = fields[26] as DateTime?
      ..activityEndDate = fields[27] as DateTime?
      ..serverDetailListModMin =
          (fields[28] as List).cast<ServerDetailDataModMinTable>()
      ..identifierDataModMin = (fields[29] as List).cast<IdentifierTable>()
      ..serverDetailListVigMin =
          (fields[30] as List).cast<ServerDetailDataVigMinTable>()
      ..identifierDataVigMin = (fields[31] as List).cast<IdentifierTable>()
      ..qrUrl = fields[32] as String;
  }

  @override
  void write(BinaryWriter writer, ActivityTable obj) {
    writer
      ..writeByte(33)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.value1)
      ..writeByte(5)
      ..write(obj.value2)
      ..writeByte(6)
      ..write(obj.total)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.weeksDate)
      ..writeByte(9)
      ..write(obj.patientId)
      ..writeByte(10)
      ..write(obj.dateTime)
      ..writeByte(11)
      ..write(obj.displayLabel)
      ..writeByte(12)
      ..write(obj.insertedDayDataId)
      ..writeByte(13)
      ..write(obj.smileyType)
      ..writeByte(14)
      ..write(obj.isCheckedDay)
      ..writeByte(15)
      ..write(obj.isCheckedDayData)
      ..writeByte(16)
      ..write(obj.notes)
      ..writeByte(17)
      ..write(obj.isOverride)
      ..writeByte(18)
      ..write(obj.isSync)
      ..writeByte(19)
      ..write(obj.objectId)
      ..writeByte(20)
      ..write(obj.iconPath)
      ..writeByte(21)
      ..write(obj.needExport)
      ..writeByte(22)
      ..write(obj.providerId)
      ..writeByte(23)
      ..write(obj.expreianceIconValue)
      ..writeByte(24)
      ..write(obj.serverDetailList)
      ..writeByte(25)
      ..write(obj.identifierData)
      ..writeByte(26)
      ..write(obj.activityStartDate)
      ..writeByte(27)
      ..write(obj.activityEndDate)
      ..writeByte(28)
      ..write(obj.serverDetailListModMin)
      ..writeByte(29)
      ..write(obj.identifierDataModMin)
      ..writeByte(30)
      ..write(obj.serverDetailListVigMin)
      ..writeByte(31)
      ..write(obj.identifierDataVigMin)
      ..writeByte(32)
      ..write(obj.qrUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
