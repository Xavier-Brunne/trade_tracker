import 'package:hive/hive.dart';

part 'user_prefs.g.dart';

@HiveType(typeId: 6) // ✅ unique typeId
class UserPrefs {
  @HiveField(0)
  final bool notificationsEnabled;

  @HiveField(1)
  final String theme; // e.g. "light" or "dark"

  @HiveField(2)
  final String language;

  UserPrefs({
    required this.notificationsEnabled,
    required this.theme,
    required this.language,
  });
}
