// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_detail_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerDetailDataTableAdapter extends TypeAdapter<ServerDetailDataTable> {
  @override
  final int typeId = 11;

  @override
  ServerDetailDataTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServerDetailDataTable()
      ..serverUrl = fields[0] as String?
      ..patientId = fields[1] as String?
      ..clientId = fields[2] as String?
      ..patientName = fields[3] as String?
      ..serverToken = fields[4] as String?
      ..objectId = fields[5] as String?
      ..dataSyncServerWise = fields[6] as bool?;
  }

  @override
  void write(BinaryWriter writer, ServerDetailDataTable obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.serverUrl)
      ..writeByte(1)
      ..write(obj.patientId)
      ..writeByte(2)
      ..write(obj.clientId)
      ..writeByte(3)
      ..write(obj.patientName)
      ..writeByte(4)
      ..write(obj.serverToken)
      ..writeByte(5)
      ..write(obj.objectId)
      ..writeByte(6)
      ..write(obj.dataSyncServerWise);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerDetailDataTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
