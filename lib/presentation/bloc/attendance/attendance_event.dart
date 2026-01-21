import 'package:equatable/equatable.dart';

/// Base class for all attendance events
sealed class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load today's meal preference counts
class LoadTodayMealPreferenceCounts extends AttendanceEvent {
  const LoadTodayMealPreferenceCounts();
}
