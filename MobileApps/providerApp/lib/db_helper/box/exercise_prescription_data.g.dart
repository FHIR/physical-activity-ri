// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_prescription_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseDataAdapter extends TypeAdapter<ExerciseData> {
  @override
  final int typeId = 97;

  @override
  ExerciseData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseData()
      ..status = fields[0] as String?
      ..priority = fields[1] as String?
      ..referralScope = fields[2] as String?
      ..isPeriodDate = fields[3] as bool
      ..startDate = fields[4] as DateTime?
      ..endDate = fields[5] as DateTime?
      ..performerId = fields[6] as String
      ..readonly = fields[7] as bool
      ..isSync = fields[8] as bool
      ..objectId = fields[9] as String?
      ..patientId = fields[10] as String?
      ..taskId = fields[11] as String?
      ..referralCode = fields[12] as String?
      ..performerName = fields[13] as String
      ..providerId = fields[14] as String
      ..createdDate = fields[15] as DateTime?
      ..lastUpdatedDate = fields[16] as DateTime?
      ..patientName = fields[17] as String
      ..providerName = fields[18] as String
      ..qrUrl = fields[19] as String
      ..token = fields[20] as String
      ..clientId = fields[21] as String
      ..textReasonCode = fields[22] as String?;
  }

  @override
  void write(BinaryWriter writer, ExerciseData obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.priority)
      ..writeByte(2)
      ..write(obj.referralScope)
      ..writeByte(3)
      ..write(obj.isPeriodDate)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.performerId)
      ..writeByte(7)
      ..write(obj.readonly)
      ..writeByte(8)
      ..write(obj.isSync)
      ..writeByte(9)
      ..write(obj.objectId)
      ..writeByte(10)
      ..write(obj.patientId)
      ..writeByte(11)
      ..write(obj.taskId)
      ..writeByte(12)
      ..write(obj.referralCode)
      ..writeByte(13)
      ..write(obj.performerName)
      ..writeByte(14)
      ..write(obj.providerId)
      ..writeByte(15)
      ..write(obj.createdDate)
      ..writeByte(16)
      ..write(obj.lastUpdatedDate)
      ..writeByte(17)
      ..write(obj.patientName)
      ..writeByte(18)
      ..write(obj.providerName)
      ..writeByte(19)
      ..write(obj.qrUrl)
      ..writeByte(20)
      ..write(obj.token)
      ..writeByte(21)
      ..write(obj.clientId)
      ..writeByte(22)
      ..write(obj.textReasonCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
