import 'package:equatable/equatable.dart';
import 'package:nsymphony_eats_dashboard/domain/model/attendance_count.dart';

/// Base class for all attendance states
sealed class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();
}

/// Loading state
class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

/// State when counts are successfully loaded
class AttendanceCountsLoaded extends AttendanceState {
  final AttendanceCount counts;

  const AttendanceCountsLoaded(this.counts);

  @override
  List<Object?> get props => [counts];
}

/// Error state
class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
