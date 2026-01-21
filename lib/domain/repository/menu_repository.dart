import 'package:nsymphony_eats_dashboard/core/error/app_error.dart';
import 'package:nsymphony_eats_dashboard/domain/model/week_menu.dart';

/// Result type for repository operations
sealed class Result<S, F> {
  const Result();
}

class Success<S, F> extends Result<S, F> {
  final S data;
  const Success(this.data);
}

class Failure<S, F> extends Result<S, F> {
  final F error;
  const Failure(this.error);
}

/// Repository interface for menu operations
abstract class MenuRepository {
  /// Get the current week's menu
  Future<Result<WeekMenu, AppError>> getCurrentWeekMenu();

  /// Stream the current week's menu for real-time updates
  Stream<Result<WeekMenu, AppError>> streamCurrentWeekMenu();
}
