// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_detail_data_vig_min.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerDetailDataVigMinTableAdapter
    extends TypeAdapter<ServerDetailDataVigMinTable> {
  @override
  final int typeId = 13;

  @override
  ServerDetailDataVigMinTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServerDetailDataVigMinTable()
      ..vigServerUrl = fields[0] as String?
      ..vigPatientId = fields[1] as String?
      ..vigClientId = fields[2] as String?
      ..vigPatientName = fields[3] as String?
      ..vigServerToken = fields[4] as String?
      ..vigObjectId = fields[5] as String?
      ..vigDataSyncServerWise = fields[6] as bool?;
  }

  @override
  void write(BinaryWriter writer, ServerDetailDataVigMinTable obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.vigServerUrl)
      ..writeByte(1)
      ..write(obj.vigPatientId)
      ..writeByte(2)
      ..write(obj.vigClientId)
      ..writeByte(3)
      ..write(obj.vigPatientName)
      ..writeByte(4)
      ..write(obj.vigServerToken)
      ..writeByte(5)
      ..write(obj.vigObjectId)
      ..writeByte(6)
      ..write(obj.vigDataSyncServerWise);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerDetailDataVigMinTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
