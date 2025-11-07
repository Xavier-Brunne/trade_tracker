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
      id: fields[0] as String,
      issuer: fields[1] as String,
      filingDate: fields[2] as String,
      accessionNumber: fields[3] as String,
      formType: fields[4] as String,
      reportDate: fields[5] as DateTime,
      isSaved: fields[6] as bool,
      source: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SecFiling obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.issuer)
      ..writeByte(2)
      ..write(obj.filingDate)
      ..writeByte(3)
      ..write(obj.accessionNumber)
      ..writeByte(4)
      ..write(obj.formType)
      ..writeByte(5)
      ..write(obj.reportDate)
      ..writeByte(6)
      ..write(obj.isSaved)
      ..writeByte(7)
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
