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
      source: fields[7] as String,
      cik: fields[8] as String?,
      reportDate: fields[5] as DateTime?,
      isSaved: fields[6] as bool,
      insiderName: fields[9] as String?,
      insiderCik: fields[10] as String?,
      transactionCode: fields[11] as String?,
      transactionShares: fields[12] as int?,
      transactionPrice: fields[13] as double?,
      documentUrl: fields[14] as String?,
      description: fields[15] as String?,
      relatedTickers: (fields[16] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SecFiling obj) {
    writer
      ..writeByte(17)
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
      ..write(obj.source)
      ..writeByte(8)
      ..write(obj.cik)
      ..writeByte(9)
      ..write(obj.insiderName)
      ..writeByte(10)
      ..write(obj.insiderCik)
      ..writeByte(11)
      ..write(obj.transactionCode)
      ..writeByte(12)
      ..write(obj.transactionShares)
      ..writeByte(13)
      ..write(obj.transactionPrice)
      ..writeByte(14)
      ..write(obj.documentUrl)
      ..writeByte(15)
      ..write(obj.description)
      ..writeByte(16)
      ..write(obj.relatedTickers);
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
