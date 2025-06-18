// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identifier_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdentifierTableAdapter extends TypeAdapter<IdentifierTable> {
  @override
  final int typeId = 5;

  @override
  IdentifierTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdentifierTable(
      objectId: fields[0] as String?,
      url: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IdentifierTable obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentifierTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
