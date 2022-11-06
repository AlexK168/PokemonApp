// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_pokemon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePokemonAdapter extends TypeAdapter<HivePokemon> {
  @override
  final int typeId = 0;

  @override
  HivePokemon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePokemon(
      name: fields[0] as String,
      weight: fields[1] as int,
      height: fields[2] as int,
      image: fields[3] as String,
      types: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HivePokemon obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.types);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePokemonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
