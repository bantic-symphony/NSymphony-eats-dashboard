import 'package:nsymphony_eats_dashboard/core/error/app_error.dart';
import 'package:nsymphony_eats_dashboard/domain/model/attendance_count.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/attendance_repository.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/menu_repository.dart';

/// Use case for streaming today's meal preference counts with real-time updates
class StreamTodayMealPreferenceCountsUseCase {
  final AttendanceRepository _repository;

  StreamTodayMealPreferenceCountsUseCase(this._repository);

  Stream<Result<AttendanceCount, AppError>> call() {
    return _repository.streamTodayMealPreferenceCounts();
  }
}
