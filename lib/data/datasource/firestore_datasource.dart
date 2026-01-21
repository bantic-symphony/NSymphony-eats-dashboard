import 'package:nsymphony_eats_dashboard/data/model/week_menu_dto.dart';

/// Data source interface for Firestore operations.
abstract interface class FirestoreDataSource {
  /// Gets a week menu document from Firestore.
  Future<WeekMenuDto?> getWeekMenu(String weekId);

  /// Stream that listens to real-time updates for a week menu document.
  Stream<WeekMenuDto?> getWeekMenuStream(String weekId);

  /// Gets today's attendance data and meal preference counts.
  ///
  /// Returns a map with:
  /// - 'cardNumbers': List of String card numbers present today
  /// - 'regular': int count of regular meals
  /// - 'vegetarian': int count of vegetarian meals
  /// - 'glutenFree': int count of gluten-free meals
  /// - 'nonPork': int count of non-pork meals
  Future<Map<String, dynamic>?> getTodayAttendanceAndPreferences();

  /// Stream that listens to real-time updates for today's attendance and preferences.
  ///
  /// Returns a stream of maps with the same structure as getTodayAttendanceAndPreferences.
  Stream<Map<String, dynamic>?> getTodayAttendanceAndPreferencesStream();
}
