// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routing_referral_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoutingReferralDataAdapter extends TypeAdapter<RoutingReferralData> {
  @override
  final int typeId = 3;

  @override
  RoutingReferralData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoutingReferralData(
      referralId: fields[0] as int?,
      status: fields[1] as String?,
      statusReason: fields[2] as String?,
      priority: fields[3] as String?,
      owner: fields[4] as String?,
      patientId: fields[6] as String?,
    )
      ..readonly = fields[5] as bool
      ..providerId = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, RoutingReferralData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.referralId)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.statusReason)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.owner)
      ..writeByte(5)
      ..write(obj.readonly)
      ..writeByte(6)
      ..write(obj.patientId)
      ..writeByte(7)
      ..write(obj.providerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutingReferralDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
