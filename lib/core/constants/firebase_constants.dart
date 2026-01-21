/// Firebase-related constants for collection names and configuration
abstract final class FirebaseConstants {
  /// Menus collection: stores weekly menus (Mon-Fri)
  static const String menusCollection = 'menus';

  /// Daily logs collection (managed by external app, read-only)
  /// Document ID format: "YYYY-MM-DD"
  static const String dailyLogsCollection = 'daily_logs';

  /// User meal preferences collection: stores user's meal type preference
  /// Document ID: cardNumber
  static const String userMealPreferencesCollection = 'user_meal_preferences';

  /// Week ID format: "YYYY-Www" (e.g., "2026-W03")
  static const String weekIdFormat = 'yyyy-Www';
}
