// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_log_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthlyLogTableDataAdapter extends TypeAdapter<MonthlyLogTableData> {
  @override
  final int typeId = 7;

  @override
  MonthlyLogTableData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthlyLogTableData(
      monthName: fields[0] as String?,
      year: fields[1] as int?,
      dayPerWeekValue: fields[2] as double?,
      avgMinValue: fields[3] as double?,
      avgMInPerWeekValue: fields[4] as double?,
      strengthValue: fields[5] as double?,
      patientId: fields[21] as String?,
    )
      ..isOverrideDayPerWeek = fields[6] as bool
      ..isOverrideAvgMin = fields[7] as bool
      ..isOverrideAvgMinPerWeek = fields[8] as bool
      ..isOverrideStrength = fields[9] as bool
      ..isSyncDayPerWeek = fields[10] as bool
      ..isSyncAvgMin = fields[11] as bool
      ..isSyncAvgMinPerWeek = fields[12] as bool
      ..isSyncStrength = fields[13] as bool
      ..startDate = fields[14] as DateTime?
      ..endDate = fields[15] as DateTime?
      ..isSync = fields[16] as bool?
      ..dayPerWeekId = fields[17] as String
      ..avgMinPerDayId = fields[18] as String
      ..avgPerWeekId = fields[19] as String
      ..strengthId = fields[20] as String
      ..qrUrl = fields[22] as String
      ..serverUrlList = (fields[23] as List).cast<String>()
      ..patientIdList = (fields[24] as List).cast<String>()
      ..clientIdList = (fields[25] as List).cast<String>()
      ..patientNameList = (fields[26] as List).cast<String>()
      ..serverTokenList = (fields[27] as List).cast<String>()
      ..serverDetailListDayPerWeek =
          (fields[28] as List).cast<ServerDetailDataTable>()
      ..serverDetailListAvgMin =
          (fields[29] as List).cast<ServerDetailDataTable>()
      ..serverDetailListAvgMinWeek =
          (fields[30] as List).cast<ServerDetailDataTable>()
      ..serverDetailListStrength =
          (fields[31] as List).cast<ServerDetailDataTable>()
      ..dayPerWeekIdentifierData = (fields[32] as List).cast<IdentifierTable>()
      ..avgMinIdentifierData = (fields[33] as List).cast<IdentifierTable>()
      ..avgMinPerWeekIdentifierData =
          (fields[34] as List).cast<IdentifierTable>()
      ..strengthIdentifierData = (fields[35] as List).cast<IdentifierTable>();
  }

  @override
  void write(BinaryWriter writer, MonthlyLogTableData obj) {
    writer
      ..writeByte(36)
      ..writeByte(0)
      ..write(obj.monthName)
      ..writeByte(1)
      ..write(obj.year)
      ..writeByte(2)
      ..write(obj.dayPerWeekValue)
      ..writeByte(3)
      ..write(obj.avgMinValue)
      ..writeByte(4)
      ..write(obj.avgMInPerWeekValue)
      ..writeByte(5)
      ..write(obj.strengthValue)
      ..writeByte(6)
      ..write(obj.isOverrideDayPerWeek)
      ..writeByte(7)
      ..write(obj.isOverrideAvgMin)
      ..writeByte(8)
      ..write(obj.isOverrideAvgMinPerWeek)
      ..writeByte(9)
      ..write(obj.isOverrideStrength)
      ..writeByte(10)
      ..write(obj.isSyncDayPerWeek)
      ..writeByte(11)
      ..write(obj.isSyncAvgMin)
      ..writeByte(12)
      ..write(obj.isSyncAvgMinPerWeek)
      ..writeByte(13)
      ..write(obj.isSyncStrength)
      ..writeByte(14)
      ..write(obj.startDate)
      ..writeByte(15)
      ..write(obj.endDate)
      ..writeByte(16)
      ..write(obj.isSync)
      ..writeByte(17)
      ..write(obj.dayPerWeekId)
      ..writeByte(18)
      ..write(obj.avgMinPerDayId)
      ..writeByte(19)
      ..write(obj.avgPerWeekId)
      ..writeByte(20)
      ..write(obj.strengthId)
      ..writeByte(21)
      ..write(obj.patientId)
      ..writeByte(22)
      ..write(obj.qrUrl)
      ..writeByte(23)
      ..write(obj.serverUrlList)
      ..writeByte(24)
      ..write(obj.patientIdList)
      ..writeByte(25)
      ..write(obj.clientIdList)
      ..writeByte(26)
      ..write(obj.patientNameList)
      ..writeByte(27)
      ..write(obj.serverTokenList)
      ..writeByte(28)
      ..write(obj.serverDetailListDayPerWeek)
      ..writeByte(29)
      ..write(obj.serverDetailListAvgMin)
      ..writeByte(30)
      ..write(obj.serverDetailListAvgMinWeek)
      ..writeByte(31)
      ..write(obj.serverDetailListStrength)
      ..writeByte(32)
      ..write(obj.dayPerWeekIdentifierData)
      ..writeByte(33)
      ..write(obj.avgMinIdentifierData)
      ..writeByte(34)
      ..write(obj.avgMinPerWeekIdentifierData)
      ..writeByte(35)
      ..write(obj.strengthIdentifierData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyLogTableDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
