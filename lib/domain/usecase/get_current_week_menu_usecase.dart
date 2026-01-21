import 'package:nsymphony_eats_dashboard/core/error/app_error.dart';
import 'package:nsymphony_eats_dashboard/domain/model/week_menu.dart';
import 'package:nsymphony_eats_dashboard/domain/repository/menu_repository.dart';

/// Use case for getting the current week's menu
class GetCurrentWeekMenuUseCase {
  final MenuRepository _repository;

  GetCurrentWeekMenuUseCase(this._repository);

  Future<Result<WeekMenu, AppError>> call() {
    return _repository.getCurrentWeekMenu();
  }
}
