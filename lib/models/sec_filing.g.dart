// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sec_filing.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SecFilingAdapter extends TypeAdapter<SecFiling> {
  @override
  final int typeId = 1;

  @override
  SecFiling read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecFiling(
      accessionNumber: fields[0] as String,
      filingDate: fields[1] as String,
      reportDate: fields[2] as String,
      issuer: fields[3] as String,
      isSaved: fields[4] as bool,
      source: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SecFiling obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.accessionNumber)
      ..writeByte(1)
      ..write(obj.filingDate)
      ..writeByte(2)
      ..write(obj.reportDate)
      ..writeByte(3)
      ..write(obj.issuer)
      ..writeByte(4)
      ..write(obj.isSaved)
      ..writeByte(5)
      ..write(obj.source);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecFilingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
