import 'package:nsymphony_eats_dashboard/core/error/app_error.dart';
import 'package:nsymphony_eats_dashboard/core/utils/app_logger.dart';
import 'package:nsymphony_eats_dashboard/core/utils/week_id_util.dart';
import 'package:nsymphony_eats_dashboard/data/datasource/firestore_datasource.dart';
import 'package:nsymphony_eats_dashboard/domain/model/week_menu.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/menu_repository.dart';

/// Implementation of [MenuRepository]
class MenuRepositoryImpl implements MenuRepository {
  final FirestoreDataSource _dataSource;

  MenuRepositoryImpl(this._dataSource);

  @override
  Future<Result<WeekMenu, AppError>> getCurrentWeekMenu() async {
    try {
      final weekId = WeekIdUtil.getCurrentWeekId();
      AppLogger.log('Getting current week menu: $weekId', tag: 'MENU_REPO');

      final dto = await _dataSource.getWeekMenu(weekId);

      if (dto == null) {
        AppLogger.log('No menu found for week: $weekId', tag: 'MENU_REPO');
        return const Failure(
          FirestoreError('No menu found for current week'),
        );
      }

      AppLogger.success('Menu loaded successfully for week: $weekId', tag: 'MENU_REPO');
      return Success(dto.toDomain());
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get current week menu',
        tag: 'MENU_REPO',
        error: e,
        stackTrace: stackTrace,
      );
      return Failure(UnknownError(e.toString()));
    }
  }

  @override
  Stream<Result<WeekMenu, AppError>> streamCurrentWeekMenu() {
    try {
      final weekId = WeekIdUtil.getCurrentWeekId();
      AppLogger.log('Streaming current week menu: $weekId', tag: 'MENU_REPO');

      return _dataSource.getWeekMenuStream(weekId).map((dto) {
        if (dto == null) {
          AppLogger.log('Stream: No menu found for week: $weekId', tag: 'MENU_REPO');
          return const Failure<WeekMenu, AppError>(
            FirestoreError('No menu found for current week'),
          );
        }
        AppLogger.success('Stream: Menu received for week: $weekId', tag: 'MENU_REPO');
        return Success<WeekMenu, AppError>(dto.toDomain());
      }).handleError((error, stackTrace) {
        AppLogger.error(
          'Stream error in menu repository',
          tag: 'MENU_REPO',
          error: error,
          stackTrace: stackTrace,
        );
        return Failure<WeekMenu, AppError>(UnknownError(error.toString()));
      });
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Failed to setup menu stream',
        tag: 'MENU_REPO',
        error: e,
        stackTrace: stackTrace,
      );
      return Stream.value(Failure(UnknownError(e.toString())));
    }
  }
}
