import 'package:nsymphony_eats_dashboard/core/error/app_error.dart';
import 'package:nsymphony_eats_dashboard/domain/model/attendance_count.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/menu_repository.dart';

/// Repository interface for attendance operations
abstract class AttendanceRepository {
  /// Get today's meal preference counts
  Future<Result<AttendanceCount, AppError>> getTodayMealPreferenceCounts();

  /// Stream today's meal preference counts for real-time updates
  Stream<Result<AttendanceCount, AppError>> streamTodayMealPreferenceCounts();
}
