import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsymphony_eats_dashboard/core/utils/app_logger.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/menu_repository.dart';
import 'package:nsymphony_eats_dashboard/domain/usecase/get_today_meal_preference_counts_usecase.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/attendance/attendance_event.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/attendance/attendance_state.dart';

/// BLoC for managing attendance state
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetTodayMealPreferenceCountsUseCase _getTodayMealPreferenceCountsUseCase;

  AttendanceBloc(this._getTodayMealPreferenceCountsUseCase)
      : super(const AttendanceInitial()) {
    on<LoadTodayMealPreferenceCounts>(_onLoadTodayMealPreferenceCounts);
  }

  Future<void> _onLoadTodayMealPreferenceCounts(
    LoadTodayMealPreferenceCounts event,
    Emitter<AttendanceState> emit,
  ) async {
    AppLogger.log('Event: LoadTodayMealPreferenceCounts', tag: 'ATTENDANCE_BLOC');
    emit(const AttendanceLoading());
    AppLogger.log('State: AttendanceLoading emitted', tag: 'ATTENDANCE_BLOC');

    final result = await _getTodayMealPreferenceCountsUseCase();

    switch (result) {
      case Success(:final data):
        AppLogger.success('Emitting AttendanceCountsLoaded: ${data.totalAttendees} attendees', tag: 'ATTENDANCE_BLOC');
        emit(AttendanceCountsLoaded(data));
      case Failure(:final error):
        AppLogger.error('Emitting AttendanceError: ${error.message}', tag: 'ATTENDANCE_BLOC');
        emit(AttendanceError(error.message));
    }
  }
}
