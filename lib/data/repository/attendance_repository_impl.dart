import 'package:nsymphony_eats_dashboard/core/error/app_error.dart';
import 'package:nsymphony_eats_dashboard/core/utils/app_logger.dart';
import 'package:nsymphony_eats_dashboard/data/datasource/firestore_datasource.dart';
import 'package:nsymphony_eats_dashboard/domain/model/attendance_count.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/attendance_repository.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/menu_repository.dart';

/// Implementation of [AttendanceRepository]
class AttendanceRepositoryImpl implements AttendanceRepository {
  final FirestoreDataSource _dataSource;

  AttendanceRepositoryImpl(this._dataSource);

  @override
  Future<Result<AttendanceCount, AppError>> getTodayMealPreferenceCounts() async {
    try {
      AppLogger.log('Getting today\'s meal preference counts', tag: 'ATTENDANCE_REPO');

      final data = await _dataSource.getTodayAttendanceAndPreferences();

      if (data == null) {
        AppLogger.log('No attendance data returned', tag: 'ATTENDANCE_REPO');
        return Failure(
          FirestoreError('Failed to fetch attendance data'),
        );
      }

      final cardNumbers = data['cardNumbers'] as List<String>;
      final regularCount = data['regular'] as int;
      final vegetarianCount = data['vegetarian'] as int;
      final glutenFreeCount = data['glutenFree'] as int;
      final nonPorkCount = data['nonPork'] as int;

      final attendanceCount = AttendanceCount(
        date: DateTime.now(),
        regularCount: regularCount,
        vegetarianCount: vegetarianCount,
        glutenFreeCount: glutenFreeCount,
        nonPorkCount: nonPorkCount,
        totalAttendees: cardNumbers.length,
      );

      AppLogger.success(
        'Attendance counts loaded: ${cardNumbers.length} total',
        tag: 'ATTENDANCE_REPO',
      );

      return Success(attendanceCount);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get meal preference counts',
        tag: 'ATTENDANCE_REPO',
        error: e,
        stackTrace: stackTrace,
      );
      return Failure(UnknownError(e.toString()));
    }
  }
}
