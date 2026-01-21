import 'package:equatable/equatable.dart';
import 'package:nsymphony_eats_dashboard/domain/model/menu_item.dart';

/// Enum representing the status of a day in the menu.
enum DayStatus {
  working,
  closed,
  noteOnly,
}

/// Enum representing the weekday.
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
}

/// Extension to convert Weekday enum to display string.
extension WeekdayExtension on Weekday {
  String get displayName {
    switch (this) {
      case Weekday.monday:
        return 'Monday';
      case Weekday.tuesday:
        return 'Tuesday';
      case Weekday.wednesday:
        return 'Wednesday';
      case Weekday.thursday:
        return 'Thursday';
      case Weekday.friday:
        return 'Friday';
    }
  }
}

/// Domain model representing a single day's menu.
class DayMenu extends Equatable {
  final DateTime date;
  final Weekday weekday;
  final DayStatus status;
  final List<MenuItem> regular;
  final List<MenuItem> vege;
  final String? note;

  const DayMenu({
    required this.date,
    required this.weekday,
    required this.status,
    required this.regular,
    required this.vege,
    this.note,
  });

  bool get hasMenu =>
      status == DayStatus.working && (regular.isNotEmpty || vege.isNotEmpty);
  bool get isClosed => status == DayStatus.closed;
  int get totalItems => regular.length + vege.length;

  DayMenu copyWith({
    DateTime? date,
    Weekday? weekday,
    DayStatus? status,
    List<MenuItem>? regular,
    List<MenuItem>? vege,
    String? note,
  }) {
    return DayMenu(
      date: date ?? this.date,
      weekday: weekday ?? this.weekday,
      status: status ?? this.status,
      regular: regular ?? this.regular,
      vege: vege ?? this.vege,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [date, weekday, status, regular, vege, note];

  @override
  String toString() =>
      'DayMenu(date: $date, weekday: $weekday, status: $status, items: $totalItems)';
}
