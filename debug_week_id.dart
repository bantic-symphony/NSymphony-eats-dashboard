// Debug script to show current week ID calculation
// Run with: dart debug_week_id.dart

void main() {
  final now = DateTime.now();
  print('═══════════════════════════════════════════════');
  print('Week ID Debug Information');
  print('═══════════════════════════════════════════════');
  print('Current date/time: $now');
  print('Day of week: ${_getDayName(now.weekday)}');
  print('Hour: ${now.hour}:${now.minute.toString().padLeft(2, '0')}');
  print('');

  // Check if we should show next week
  bool showNextWeek = false;
  String reason = '';

  if (now.weekday == DateTime.friday && now.hour >= 15) {
    showNextWeek = true;
    reason = 'Friday after 15:00 - showing next week';
  } else if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
    showNextWeek = true;
    reason = 'Weekend - showing next week';
  } else {
    reason = 'Showing current week';
  }

  print('📅 Logic: $reason');
  print('');

  // Calculate which date to use
  DateTime targetDate = now;
  if (now.weekday == DateTime.friday && now.hour >= 15) {
    targetDate = now.add(const Duration(days: 7));
  } else if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
    final daysUntilMonday = (DateTime.monday + 7 - now.weekday) % 7;
    targetDate = now.add(Duration(days: daysUntilMonday));
  }

  // Calculate ISO week number (same logic as WeekIdUtil)
  final thursday = targetDate.add(Duration(days: DateTime.thursday - targetDate.weekday));
  final firstDayOfYear = DateTime(thursday.year, 1, 1);
  final firstThursday = firstDayOfYear.add(
    Duration(days: (DateTime.thursday - firstDayOfYear.weekday + 7) % 7),
  );
  final weekNumber = ((thursday.difference(firstThursday).inDays / 7).floor() + 1);
  final weekId = '${targetDate.year}-W${weekNumber.toString().padLeft(2, '0')}';

  print('Target date for calculation: $targetDate');
  print('Week number: $weekNumber');
  print('Week ID: $weekId');
  print('');
  print('═══════════════════════════════════════════════');
  print('This is the document ID the app is looking for in Firestore');
  print('Collection: menus');
  print('Document ID: $weekId');
  print('═══════════════════════════════════════════════');
  print('');
  print('To fix the issue:');
  print('1. Check your Firestore console');
  print('2. Go to the "menus" collection');
  print('3. Make sure there\'s a document with ID: $weekId');
  print('4. If not, check what document IDs exist and adjust accordingly');
}

String _getDayName(int weekday) {
  switch (weekday) {
    case DateTime.monday: return 'Monday';
    case DateTime.tuesday: return 'Tuesday';
    case DateTime.wednesday: return 'Wednesday';
    case DateTime.thursday: return 'Thursday';
    case DateTime.friday: return 'Friday';
    case DateTime.saturday: return 'Saturday';
    case DateTime.sunday: return 'Sunday';
    default: return 'Unknown';
  }
}
