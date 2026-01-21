import 'package:equatable/equatable.dart';
import 'package:nsymphony_eats_dashboard/domain/model/day_menu.dart';

/// Domain model representing a complete week's menu.
class WeekMenu extends Equatable {
  final String id;
  final DateTime weekStart;
  final List<DayMenu> days;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime? publishedAt;
  final String createdBy;

  const WeekMenu({
    required this.id,
    required this.weekStart,
    required this.days,
    required this.isPublished,
    required this.createdAt,
    this.publishedAt,
    required this.createdBy,
  }) : assert(days.length == 5, 'Week menu must have exactly 5 days (Mon-Fri)');

  DayMenu? getDayMenu(Weekday weekday) {
    try {
      return days.firstWhere((day) => day.weekday == weekday);
    } catch (e) {
      return null;
    }
  }

  DayMenu? getDayMenuByDate(DateTime date) {
    try {
      return days.firstWhere((day) =>
          day.date.year == date.year &&
          day.date.month == date.month &&
          day.date.day == date.day);
    } catch (e) {
      return null;
    }
  }

  bool get isComplete => days.every((day) => day.hasMenu);
  int get workingDaysCount =>
      days.where((day) => day.status == DayStatus.working).length;
  int get totalItems => days.fold(0, (sum, day) => sum + day.totalItems);

  WeekMenu copyWith({
    String? id,
    DateTime? weekStart,
    List<DayMenu>? days,
    bool? isPublished,
    DateTime? createdAt,
    DateTime? publishedAt,
    String? createdBy,
  }) {
    return WeekMenu(
      id: id ?? this.id,
      weekStart: weekStart ?? this.weekStart,
      days: days ?? this.days,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      publishedAt: publishedAt ?? this.publishedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [
        id,
        weekStart,
        days,
        isPublished,
        createdAt,
        publishedAt,
        createdBy,
      ];

  @override
  String toString() =>
      'WeekMenu(id: $id, published: $isPublished, workingDays: $workingDaysCount, items: $totalItems)';
}
