// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_prefs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPrefsAdapter extends TypeAdapter<UserPrefs> {
  @override
  final int typeId = 6;

  @override
  UserPrefs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPrefs(
      notificationsEnabled: fields[0] as bool,
      theme: fields[1] as String,
      language: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserPrefs obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.notificationsEnabled)
      ..writeByte(1)
      ..write(obj.theme)
      ..writeByte(2)
      ..write(obj.language);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPrefsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
