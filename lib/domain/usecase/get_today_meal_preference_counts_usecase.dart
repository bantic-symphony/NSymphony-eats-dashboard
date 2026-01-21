import 'package:nsymphony_eats_dashboard/core/error/app_error.dart';
import 'package:nsymphony_eats_dashboard/domain/model/attendance_count.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/attendance_repository.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/menu_repository.dart';

/// Use case for getting today's meal preference counts
class GetTodayMealPreferenceCountsUseCase {
  final AttendanceRepository _repository;

  GetTodayMealPreferenceCountsUseCase(this._repository);

  Future<Result<AttendanceCount, AppError>> call() {
    return _repository.getTodayMealPreferenceCounts();
  }
}
