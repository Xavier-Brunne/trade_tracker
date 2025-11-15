import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 2) // ✅ unique typeId
class Settings {
  @HiveField(0)
  final bool darkMode;

  @HiveField(1)
  final String preferredLanguage;

  Settings({
    required this.darkMode,
    required this.preferredLanguage,
  });
}
