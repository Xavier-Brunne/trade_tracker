// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cik_cache_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CikCacheEntryAdapter extends TypeAdapter<CikCacheEntry> {
  @override
  final int typeId = 3;

  @override
  CikCacheEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CikCacheEntry(
      ticker: fields[0] as String,
      cik: fields[1] as String,
      cachedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CikCacheEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.ticker)
      ..writeByte(1)
      ..write(obj.cik)
      ..writeByte(2)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CikCacheEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
