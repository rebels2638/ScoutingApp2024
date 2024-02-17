// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ephemeral_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EphemeralScoutingDataAdapter extends TypeAdapter<EphemeralScoutingData> {
  @override
  final int typeId = 0;

  @override
  EphemeralScoutingData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EphemeralScoutingData(
      fields[2] as String,
      compressedFormat: fields[0] as String,
      telemetryVersion: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EphemeralScoutingData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.compressedFormat)
      ..writeByte(1)
      ..write(obj.telemetryVersion)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EphemeralScoutingDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
