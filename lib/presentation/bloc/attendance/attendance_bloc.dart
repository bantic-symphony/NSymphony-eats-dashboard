import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsymphony_eats_dashboard/core/utils/app_logger.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/menu_repository.dart';
import 'package:nsymphony_eats_dashboard/domain/usecase/get_today_meal_preference_counts_usecase.dart';
import 'package:nsymphony_eats_dashboard/domain/usecase/stream_today_meal_preference_counts_usecase.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/attendance/attendance_event.dart';
import 'package:nsymphony_eats_dashboard/presentation/bloc/attendance/attendance_state.dart';

/// BLoC for managing attendance state
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetTodayMealPreferenceCountsUseCase _getTodayMealPreferenceCountsUseCase;
  final StreamTodayMealPreferenceCountsUseCase _streamTodayMealPreferenceCountsUseCase;
  StreamSubscription? _attendanceSubscription;

  AttendanceBloc(
    this._getTodayMealPreferenceCountsUseCase,
    this._streamTodayMealPreferenceCountsUseCase,
  ) : super(const AttendanceInitial()) {
    on<LoadTodayMealPreferenceCounts>(_onLoadTodayMealPreferenceCounts);
    on<SubscribeToTodayMealPreferenceCounts>(_onSubscribeToTodayMealPreferenceCounts);
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

  Future<void> _onSubscribeToTodayMealPreferenceCounts(
    SubscribeToTodayMealPreferenceCounts event,
    Emitter<AttendanceState> emit,
  ) async {
    AppLogger.log('Event: SubscribeToTodayMealPreferenceCounts', tag: 'ATTENDANCE_BLOC');
    emit(const AttendanceLoading());
    AppLogger.log('State: AttendanceLoading emitted', tag: 'ATTENDANCE_BLOC');

    await _attendanceSubscription?.cancel();

    await emit.forEach(
      _streamTodayMealPreferenceCountsUseCase(),
      onData: (result) {
        AppLogger.log('Stream result received in emit.forEach', tag: 'ATTENDANCE_BLOC');
        switch (result) {
          case Success(:final data):
            AppLogger.success('Returning AttendanceCountsLoaded state: ${data.totalAttendees} attendees', tag: 'ATTENDANCE_BLOC');
            return AttendanceCountsLoaded(data);
          case Failure(:final error):
            AppLogger.error('Returning AttendanceError state: ${error.message}', tag: 'ATTENDANCE_BLOC');
            return AttendanceError(error.message);
        }
      },
      onError: (error, stackTrace) {
        AppLogger.error('Stream error in emit.forEach', tag: 'ATTENDANCE_BLOC', error: error, stackTrace: stackTrace);
        return AttendanceError(error.toString());
      },
    );
  }

  @override
  Future<void> close() {
    _attendanceSubscription?.cancel();
    return super.close();
  }
}
