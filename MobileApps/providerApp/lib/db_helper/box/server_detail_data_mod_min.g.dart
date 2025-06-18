// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_detail_data_mod_min.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerDetailDataModMinTableAdapter
    extends TypeAdapter<ServerDetailDataModMinTable> {
  @override
  final int typeId = 12;

  @override
  ServerDetailDataModMinTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServerDetailDataModMinTable()
      ..modServerUrl = fields[0] as String?
      ..modPatientId = fields[1] as String?
      ..modClientId = fields[2] as String?
      ..modPatientName = fields[3] as String?
      ..modServerToken = fields[4] as String?
      ..modObjectId = fields[5] as String?
      ..modDataSyncServerWise = fields[6] as bool?;
  }

  @override
  void write(BinaryWriter writer, ServerDetailDataModMinTable obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.modServerUrl)
      ..writeByte(1)
      ..write(obj.modPatientId)
      ..writeByte(2)
      ..write(obj.modClientId)
      ..writeByte(3)
      ..write(obj.modPatientName)
      ..writeByte(4)
      ..write(obj.modServerToken)
      ..writeByte(5)
      ..write(obj.modObjectId)
      ..writeByte(6)
      ..write(obj.modDataSyncServerWise);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerDetailDataModMinTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
