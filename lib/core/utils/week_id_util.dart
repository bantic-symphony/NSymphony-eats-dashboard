/// Utility class for working with week IDs
class WeekIdUtil {
  /// Generates a week ID for a given date
  /// Format: "YYYY-Www" (e.g., "2026-W03")
  static String getWeekId(DateTime date) {
    // Calculate ISO 8601 week number manually
    final weekNumber = _getISOWeekNumber(date);
    return '${date.year}-W${weekNumber.toString().padLeft(2, '0')}';
  }

  /// Gets the week ID for the current week
  static String getCurrentWeekId() {
    return getWeekId(DateTime.now());
  }

  /// Calculates ISO 8601 week number for a given date
  static int _getISOWeekNumber(DateTime date) {
    // Find Thursday of the current week (ISO 8601 week definition)
    final thursday = date.add(Duration(days: DateTime.thursday - date.weekday));

    // Find the first Thursday of the year
    final firstDayOfYear = DateTime(thursday.year, 1, 1);
    final firstThursday = firstDayOfYear.add(
      Duration(days: (DateTime.thursday - firstDayOfYear.weekday + 7) % 7),
    );

    // Calculate week number
    final weekNumber = ((thursday.difference(firstThursday).inDays / 7).floor() + 1);
    return weekNumber;
  }

  /// Gets the start date (Monday) for a given week ID
  static DateTime getWeekStartDate(String weekId) {
    // Parse week ID: "2026-W03"
    final parts = weekId.split('-W');
    final year = int.parse(parts[0]);
    final week = int.parse(parts[1]);

    // Find the first Thursday of the year (ISO 8601 week starts with Monday)
    final jan4 = DateTime(year, 1, 4);
    final daysToMonday = (jan4.weekday - DateTime.monday) % 7;
    final firstMonday = jan4.subtract(Duration(days: daysToMonday));

    // Add weeks
    return firstMonday.add(Duration(days: (week - 1) * 7));
  }
}
