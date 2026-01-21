import 'package:nsymphony_eats_dashboard/core/error/app_error.dart';
import 'package:nsymphony_eats_dashboard/domain/model/week_menu.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/menu_repository.dart';

/// Use case for streaming the current week's menu
class StreamCurrentWeekMenuUseCase {
  final MenuRepository _repository;

  StreamCurrentWeekMenuUseCase(this._repository);

  Stream<Result<WeekMenu, AppError>> call() {
    return _repository.streamCurrentWeekMenu();
  }
}
